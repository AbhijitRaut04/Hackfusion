.PHONY: run-frontend run-backend start

# Run frontend using npm run dev
# run-frontend:
# 	cd frontend && npm run dev

# Run backend using npm start
run-backend:
	cd CloudCampus-Backend && npm start

# Run both frontend and backend concurrently
# start:
# 	@make -j2 run-frontend run-backend
