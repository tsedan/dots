function make_venv --description "Create a Python3 virtual environment"
  python3 -m venv .env
  and echo "source .env/bin/activate" >> .envrc
  and direnv allow .
end
