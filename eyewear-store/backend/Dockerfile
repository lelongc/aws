FROM node:18-alpine

WORKDIR /app

# Cài đặt PNPM
RUN npm install -g pnpm

# Copy package.json và pnpm-lock.yaml
COPY package.json pnpm-lock.yaml ./

# Cài đặt dependencies
RUN pnpm install

# Copy source code
COPY . .

# Biên dịch TypeScript
RUN pnpm run build

# Expose cổng 4000
EXPOSE 4000

# Chạy ứng dụng
CMD ["pnpm", "run", "start:dev"]
