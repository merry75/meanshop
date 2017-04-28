FROM nginx:alpine
COPY nginx/meanshop.conf /etc/nginx/conf.d/default.conf
COPY client /meanshop/current/dist/public
