# ---------- Stage 1: Build ----------
    FROM node:20-alpine AS builder

    # Create app directory
    WORKDIR /app
    
    # Install dependencies
    COPY package.json yarn.lock ./
    RUN yarn install
    
    # Copy source code and build
    COPY . .
    RUN yarn build
    
    # ---------- Stage 2: Serve ----------
    FROM node:20-alpine
    
    # Create non-root user
    RUN addgroup -g 1001 appgroup && adduser -D -G appgroup -u 1001 appuser
    
    # Install `serve`
    RUN yarn global add serve
    
    # Copy build output from builder
    COPY --from=builder /app/build /app/build
    
    # Set working directory and ownership
    WORKDIR /app
    RUN chown -R appuser:appgroup /app
    
    # Switch to non-root user
    USER appuser
    
    # Expose port and run app
    EXPOSE 3000
    CMD ["serve", "-s", "build", "-l", "3000"]
    