#!/usr/bin/env bash

#V1_DIR="/home/hee/v1"
V2_DIR="/home/hee/v2"
#APP_DIR="/home/hee/app"
LOG_DIR="/home/hee/log"
JAR_FILE="/home/hee/app/execute.jar"

APP_LOG="$LOG_DIR/application.log"
#ERROR_LOG="$LOG_DIR/error.log"
DEPLOY_LOG="$LOG_DIR/deploy.log"

TIME_NOW=$(date +%c)

# build 파일 복사
echo "$TIME_NOW > $JAR_FILE 파일 복사" >> $DEPLOY_LOG
cp $V2_DIR/*.jar $JAR_FILE

# jar 파일 실행
echo "$TIME_NOW > $JAR_FILE 파일 실행" >> $DEPLOY_LOG
sudo nohup java -jar $JAR_FILE | sudo tee $APP_LOG

CURRENT_PID=$(pgrep -f $JAR_FILE)
echo "$TIME_NOW > 실행된 프로세스 아이디 $CURRENT_PID 입니다." >> $DEPLOY_LOG