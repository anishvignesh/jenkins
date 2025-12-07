import subprocess
import smtplib
from email.mime.text import MIMEText

def send_mail(msg):
    sender = "yourmail@gmail.com"
    receiver = "yourmail@gmail.com"
    subject = "Nginx Job Failed"
    body = msg

    msg = MIMEText(body)
    msg["Subject"] = subject
    msg["From"] = sender
    msg["To"] = receiver

    s = smtplib.SMTP("smtp.gmail.com", 587)
    s.starttls()
    s.login(sender, "YOUR-APP-PASSWORD")
    s.sendmail(sender, receiver, msg.as_string())
    s.quit()

def check_nginx():
    cmd = ["systemctl", "status", "nginx"]
    result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return result.returncode

if __name__ == "__main__":
    status = check_nginx()
    if status != 0:
        send_mail("NGINX Service is not running!")
        exit(1)
