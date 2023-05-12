# multi stage dockerfile
# Build Stage
FROM node:12-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Deploy Stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

###################################
# Example 2: Python Application with Multiple Dependencies


# Build Stage
FROM python:3.9-slim-buster as build
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN python setup.py install

# Deploy Stage
FROM python:3.9-slim-buster
WORKDIR /app
COPY --from=build /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY app.py .
CMD ["python", "app.py"]

