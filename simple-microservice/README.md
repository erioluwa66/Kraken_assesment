# Kraken_assesment

A take home assisgnment from the Kraken team
## Prerequisites
    Python 3.9 or later
    pip (Python package installer)
    Docker
    Git Bash or any terminal
## Setup Instructions for the Microservices app

1) Clone the Repository
    ```
    git clone https://github.com/erioluwa66/Kraken_assesment.git
    cd simple-microservice
    ```
2) Ensure to have python3 installed in your local environment, then Set Up the Virtual Environment
    a. Create a virtual environment:
        ```
        python -m venv venv
         ```
    b.  Activate the virtual environment:
        Powershell:
            ```
           .\venv\Scripts\Activate
            ``` 
        Command Prompt (cmd):
            ```
           venv\Scripts\activate
            ```
        Git Bash or WSL:
            ```
           source venv/Scripts/activate
            ```
3) Install Dependencies 
    ```    
        pip install -r requirements.txt
    ```

4)  Downgrade Werkzeug (to resolve compatibility issue)  
    ```
        pip install werkzeug==2.0.3
    ```
5)  Run the Flask App 
    ```
        python app.py
    ```
6) Test the application
    Open your browser and navigate to http://localhost:5000/greet. You should see a JSON response with the greeting message.
    ```
        json
        Copy code
        {
        "message": "Hello, welcome to our service!"
        }
    ```
7) Deactivate the Virtual Environment
    ```
       deactivate
    ```
8)  Build the Docker Image
    ```
       docker build -t flask-microservice .
    ```
9) Run the Docker Container
    ```
        docker run -p 5000:5000 simple-microservice
    ```
10) Test the application
    Open your browser and navigate to http://localhost:5000/greet. You should see the JSON response as described earlier.

11) Stop the Docker Container
        To stop the container 
        ```
            docker ps
        ```
    
### Endpoints
This app's API server has the following endpoint:

- `GET /greet`: Retrieve the greet message
- RESPONSES: 
  - 200 success for all GET  requests
  - 404 not found

### Troubleshooting
If you encounter any issues with the virtual environment, ensure you are using the correct command to activate it based on your terminal.
If the app does not run, make sure all dependencies are installed and the correct version of Werkzeug is used.
If you encounter issues with Docker, ensure Docker is running and check for port conflicts.