import subprocess
from flask import Flask, render_template
from flask_bootstrap import Bootstrap
from flask import request


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
	return output

if __name__ == "__main__":
    app.run(debug=True)
	# return render_template("index.html",output=output)