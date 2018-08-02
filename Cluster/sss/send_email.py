import smtplib
import sys
from email.mime.multipart import MIMEMultipart as text


########### Crredentials #####################
gmail_user = 'teliscos@gmail.com'
gmail_password = '***************' # App Password
##############################################
sent_from = gmail_user
_help = "commmand <email to> <subject> <file/text> <file path/content>"

try:
    to = str(sys.argv[1])
    to = to.split(",")
    subject = str(sys.argv[2])
    opt = str(sys.argv[3])

except:
    print(_help)
    sys.exit()

if opt == "file":
    try:
        body = str(sys.argv[4])
        file_con = open(body,"r")
        body = file_con.read()
    except:
        print("Path Error")
else:
    body=opt


email_text = """ From: From Person <{}>
To: To Person <{}>
MIME-Version: 1.0
Content-type: text/html
Subject: {}

{}
""".format(sent_from, ", ".join(to), subject, body)

try:
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.ehlo()
    server.login(gmail_user, gmail_password)
    server.sendmail(sent_from, to, email_text)
    server.close()

    print('Email sent!')
except:
    print('Something went wrong...')


