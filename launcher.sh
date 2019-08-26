# launch Flask Manager and daemon:
flask run &
echo $'\n' app.py launched! $'\n'

while :
do
python3 Flask_Manager/daemon.py
sleep 2
done