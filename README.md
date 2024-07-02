# NextChat-Feishu
使用Feishu OAuth控制NextChat访问权限

## feishu app

1. 创建app
2. 配置app安全设置，重定向url：`$DOMAIN/feishu_auth_callback`（这里的$DOMAIN和后面启动容器使用的一致，domain支持内网ip地址）
3. 获取APP_ID以及APP_SECRET
4. 发布应用


## docker
```
docker build -t d.nextchat.dev:5000/nextchat-feishu 

docker run --rm -it -e BASE_URL= -e OPENAI_API_KEY=sk-xxx -e DOMAIN=dddd -e APP_ID=cli_xxx -e APP_SECRET=xxx -p 80:80 d.nextchat.dev:5000/nextchat-feishu
```

## docker-compose
```
docker-compose build nextchat

# 使用环境变量启动docker-compose服务
BASE_URL=xxxx OPENAI_API_KEY=sk-xxx DOMAIN=dddd APP_ID=cli_xxx APP_SECRET=xxx docker-compose up -d
```

