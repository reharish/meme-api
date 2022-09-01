from app import app

bind = "0.0.0.0:8080"
workers = 2

if __name__ == "__main__":
	app.run()

