FROM node:10 as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ARG API_URI
ENV API_URI ${API_URI:-http://10.0.0.99:8000/graphql/}
ARG FORCE_SLL
ENV FORCE_SLL ${FORCE_SLL:-http://10.0.0.99:8000/graphql/}
RUN API_URI=${API_URI} FORCE_SLL=${FORCE_SLL} npm run build

FROM nginx:stable
WORKDIR /app
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist/ /app/
