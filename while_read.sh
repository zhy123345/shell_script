#!/bin/bash
file=slave_list.txt 
sed -i 's;\t; ;g' slave_list.txt

JOB_TEMPLATE="Job_Template"
NODE_TEMPLATE="Node_Template"


IFS=" "
#read -p命令，原本经常用来读取用户输入作为变量值；
#while read line1 line2 也是常用方式；line1 line2表示while循环结束符done后面重定向输入的$file文件中的数据；
#IFS 用来指定默认的域分隔符，表示读取$file文件时按空格分隔读取；
#使用以上语法结构，也可以读取非文件中的值，例如IFS=:,echo $PATH
while read project ip #按空格分隔读取$file文件数据，赋值给变量project ip
do 	
  echo project=$project ip=$ip

	#修改工程配置文件
	JOB_PATH="/root/.jenkins/jobs/$project" 
	echo ==job_path="$JOB_PATH"==
	if [ ! -d "$JOB_PATH" ]; then
	mkdir $JOB_PATH
	fi  
		echo ==1.1==
		echo cp $JOB_TEMPLATE/* $JOB_PATH -R
		cp $JOB_TEMPLATE/* $JOB_PATH -R
		
		echo ==1.2==
		
		sed -i 's;<assignedNode>.*<\/assignedNode>;<assignedNode>'"${project}"'<\/assignedNode>;g' $JOB_PATH/config.xml
	
	
	#修改slave节点配置文件
	SLAVE_PATH="/root/.jenkins/nodes/${project}_${ip}"
	echo ==slave_path="$SLAVE_PATH"==
	if [ ! -d "$SLAVE_PATH" ]; then  
		echo ==2.1==
		cp $NODE_TEMPLATE $SLAVE_PATH -R
		echo ==2.2==
		sed -i 's;<name>.*<\/name>;<name>'"${project}_${ip}"'<\/name>;g' ${SLAVE_PATH}/config.xml		
		sed -i 's;<host>.*<\/host>;<host>'"${ip}"'<\/host>;g' ${SLAVE_PATH}/config.xml
		sed -i 's;<label>.*<\/label>;<label>'"${project}"'<\/label>;g' ${SLAVE_PATH}/config.xml		
	fi
	
	sed -i 's;<credentialsId>.*<\/credentialsId>;<credentialsId>'"6bbf2ff6-32ab-4b13-a4b4-39a0c8b4af93"'<\/credentialsId>;g' ${SLAVE_PATH}/config.xml
	echo ====next====
	echo $file
done < $file
	echo ====end====
