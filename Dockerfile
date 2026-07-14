# Stage 1: Dependências base
FROM node:20-alpine AS base
WORKDIR /app

# Stage 2: Instalação de dependências
FROM base AS deps
RUN apk add --no-cache libc6-compat
COPY package.json package-lock.json* ./
RUN npm i

# Stage 3: Build da aplicação
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Desabilita a telemetria do Next.js
ENV NEXT_TELEMETRY_DISABLED=1

# ====================================================================
# BYPASS PORTAINER BUG: Variáveis fixas diretamente no ENV
# É 100% seguro deixar chaves NEXT_PUBLIC hardcoded aqui no repositório
# ====================================================================
ENV NEXT_PUBLIC_SUPABASE_URL="https://geutluacdzinowdburmm.supabase.co"
ENV NEXT_PUBLIC_SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdldXRsdWFjZHppbm93ZGJ1cm1tIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM4OTU5NzksImV4cCI6MjA5OTQ3MTk3OX0.Ua-K7udKFQ7T95TK8dv6LJG5_w88YfeW02A66vnbweo"
# ADICIONE ESTAS DUAS LINHAS:
ENV NEXT_PUBLIC_SITE_URL="https://crm.techrocket.site"
ENV NEXT_PUBLIC_APP_LOCALE="en"

RUN npm run build

# Stage 4: Imagem final de execução
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copia os arquivos públicos e o output standalone gerado pelo Next.js
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["node", "server.js"]
