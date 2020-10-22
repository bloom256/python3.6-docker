docker run -it -d --name python3.6 \
--gpus all \
--env="DISPLAY" \
--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
-e QT_X11_NO_MITSHM=1 \
-v /home/dan/data:/data \
-v /home/dan/src:/src \
-p 8888:8888 \
python3.6
