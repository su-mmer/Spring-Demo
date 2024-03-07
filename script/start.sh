#! /bin/bash

number=0
while [ "$number" -lt 1 ]
#for i in 1
do
  echo "This is first flag: $number" >> "flag.text"
  V1_DIR="/home/hee/v1"
  V2_DIR="/home/hee/v2"
  APP_DIR="/home/hee/app"
  LOG_DIR="/home/hee/log"
  JAR_FILE="$APP_DIR/*.jar"

  APP_LOG="$LOG_DIR/application.log"
  ERROR_LOG="$LOG_DIR/error.log"
  DEPLOY_LOG="$LOG_DIR/deploy.log"

  TIME_NOW=$(date +%c)

  ### 1. v2 파일 실행 dir로 복사 ###
  echo "$TIME_NOW > $JAR_FILE 파일 복사" >> $DEPLOY_LOG
  cp $V2_DIR/*.jar $APP_DIR/v2.jar

  ### 2. 기존 app 종료 ###
  # 현재 구동 중인 애플리케이션 pid 확인
  CURRENT_PID=$(pgrep -f $APP_DIR/*.jar)

  # 프로세스가 켜져 있으면 종료
  if [ -z "$CURRENT_PID" ]; then
    echo "$TIME_NOW > 현재 실행중인 애플리케이션이 없습니다" >> $DEPLOY_LOG
  else
    echo "$TIME_NOW > 실행중인 $CURRENT_PID 애플리케이션 종료 " >> $DEPLOY_LOG
    kill -15 "$CURRENT_PID"
  fi

  ### 3. 새 jar 파일 실행 ###
  echo "$TIME_NOW > v2 파일 실행" >> $DEPLOY_LOG
  nohup java -jar $APP_DIR/*.jar >> $APP_LOG 2> $ERROR_LOG &
  sleep 10;

  ### 4. 상태코드 확인 ###
  RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
  echo "$RESPONSE_CODE" > "response.text"
  CODE=$(cat "response.text")

  if [ "$CODE" -eq 200 ]; then # 4-1. http 200(성공) -> v2를 v1로 덮어쓰기
    echo "v2 success, copy to v1" >> $DEPLOY_LOG
    cp $V2_DIR/*.jar $V1_DIR/v1.jar
  else # 4-2. 실패 -> 롤백하고 다시 실행시키기
    echo "v2 failure, roll back to v1" >> $DEPLOY_LOG
    cp $V1_DIR/*.jar $APP_DIR/v1.jar
    nohup java -jar $APP_DIR/*.jar >> $APP_LOG 2> $ERROR_LOG &
  fi

  CURRENT_PID=$(pgrep -f $APP_DIR/*.jar)
  echo "$TIME_NOW > 실행된 프로세스 아이디 $CURRENT_PID 입니다." >> $DEPLOY_LOG

#  ((number++))
  number=$((number+1))
  echo "This is last flag: $number" >> "flag.text"
done