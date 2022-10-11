import subprocess
from flask import Flask, render_template
from flask_bootstrap import Bootstrap


app = Flask(__name__)
bootstrap = Bootstrap(app)

@app.route('/')
# @app.route('/index')
def index():
    command = request.args.get('ping') if request.args.get('ping') else None
	if command:
		output = subprocess.check_output(command, shell=True)
	else:
		output = "None"
	# return render_template("index.html",output=output)