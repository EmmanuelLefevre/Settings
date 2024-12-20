# INTERACTIVE LOGIN SHELL

#---------------#
# PROMPT THEMES #
#---------------#
########## Profil loaded in Powershell ##########
eval "$(oh-my-posh init bash --config "$HOME\Documents\GitBash\gitbash_profile_darka.json")"

#############################################################################################

#---------#
# ALIASES #
#---------#
########## Test GitHub SSH connection ##########
alias ssh='ssh -T git@github.com'

#############################################################################################

#-----------#
# UTILITIES #
#-----------#
########## Base path ##########
BASE_PATH="C:/Users/<USERNAME>"

########## Default commit message ##########
DEFAULT_COMMIT_MESSAGE="maj"

########## ANSI colors ##########
BLUE='\033[0;34m'
CYAN='\033[36m'
MAGENTA='\033[0;35m'
RED='\033[31m'
NC='\033[0m'

########## Local repositories dictionary ##########
declare -A LocalRepos
LocalRepos["aw"]="$BASE_PATH/Desktop/Projets/ArtiWave"
LocalRepos["cours"]="$BASE_PATH/Desktop/Cours"
LocalRepos["docs"]="$BASE_PATH/Documents/Documentations"
LocalRepos["dotfiles"]="$BASE_PATH/Desktop/Dotfiles"
LocalRepos["mdimg"]="$BASE_PATH/Desktop/MarkdownImg"
LocalRepos["portfolio"]="$BASE_PATH/Desktop/Projets/IAmEmmanuelLefevre"
LocalRepos["profile"]="$BASE_PATH/Desktop/Projets/EmmanuelLefevre"
LocalRepos["replica"]="$BASE_PATH/Desktop/Projets/ReplicaMySQL"
LocalRepos["schemas"]="$BASE_PATH/Desktop/Schemas"
LocalRepos["soutenances"]="$BASE_PATH/Desktop/Soutenances"

#############################################################################################

#-----------#
# FUNCTIONS #
#-----------#
########## Help ##########
help() {
  echo -e "${BLUE}| Commande | Description                                         |${NC}"
  echo    "|----------|-----------------------------------------------------|"
  echo    "| push     | Automatic commit message push                       |"
  echo    "| go       | Jump to a specific directory                        |"
  echo    "| ssh      | Test GitHub SSH connection                          |"
  echo -e "| z        | Go specified folder / returns parent directory      |\n"
}

########## Navigate to the specified folder passed as a parameter ##########
########## Or returns to parent directory if no paramater is specified ##########
z() {
  if [ -z "$1" ]; then
    # If no parameter is specified, returns to parent directory
    cd ..
  else
    # If an argument is passed, go to the specified folder
    if cd "$1" 2>/dev/null; then
      :
    else
      echo "⚠️ Folder '$1' not found ⚠️"
    fi
  fi
}

########## Automatic commit message push with directory navigation ##########
push() {
  # If first argument is "help", display available options
  if [[ $1 == "help" ]]; then
    echo -e "\n${BLUE}| Option          | Path                                               |${NC}"
    echo    "|-----------------|----------------------------------------------------|"
    for repo in $(printf "%s\n" "${!LocalRepos[@]}" | sort); do
      printf "| %-15s | %-50s |\n" "$repo" "${LocalRepos[$repo]}"
    done
    echo
    return
  fi

  local repo_name=$1
  # Use DEFAULT_COMMIT_MESSAGE if none is provided
  local commit_message=${2:-$DEFAULT_COMMIT_MESSAGE}

  # Display repoName in PascalCase
  local formatted_repo_name="${repo_name^}"

  if [ -n "${LocalRepos[$repo_name]}" ]; then
    cd "${LocalRepos[$repo_name]}"
    git add .
    git commit -m "$commit_message"
    git push
    echo -e "${CYAN}$formatted_repo_name${NC} has been successfully updated 🤙"
  else
    echo -e "⚠️ Error: local repository ${RED}$formatted_repo_name${NC} not found! ⚠️"
  fi
}

########## Jump to a specific directory ##########
go() {
  # Dictionary definition of paths
  declare -A PATHS
  PATHS=(
    ["aw"]="$BASE_PATH/Desktop/Projets/ArtiWave"
    ["cours"]="$BASE_PATH/Desktop/Cours"
    ["docs"]="$BASE_PATH/Documents/Documentations"
    ["dotfiles"]="$BASE_PATH/Desktop/Dotfiles"
    ["dwld"]="$BASE_PATH/Downloads"
    ["eg"]="$BASE_PATH/Desktop/Projets/EasyGarden"
    ["mdimg"]="$BASE_PATH/Desktop/MarkdownImg"
    ["portfolio"]="$BASE_PATH/Desktop/Projets/IAmEmmanuelLefevre"
    ["profile"]="$BASE_PATH/Desktop/Projets/EmmanuelLefevre"
    ["projets"]="$BASE_PATH/Desktop/Projets"
    ["replica"]="$BASE_PATH/Desktop/Projets/ReplicaMySQL"
    ["schemas"]="$BASE_PATH/Desktop/Schemas"
    ["soutenances"]="$BASE_PATH/Desktop/Soutenances"
  )

  # If first argument is "help", display available options
  if [[ $1 == "help" ]]; then
    echo -e "\n${BLUE}| Option         | Path                                               |${NC}"
    echo    "|----------------|----------------------------------------------------|"
    for key in $(printf "%s\n" "${!PATHS[@]}" | sort); do
      printf "| %-14s | %-50s |\n" "$key" "${PATHS[$key]}"
    done
    echo
    return
  fi

  # Checks if the argument is a valid key
  if [[ -n "${PATHS[$1]}" ]]; then
    cd "${PATHS[$1]}" 2>/dev/null || echo "Error: Path '${PATHS[$1]}' doesn't exists!"
  else
    echo "Available paths :"
    for key in $(printf "%s\n" "${!PATHS[@]}" | sort); do
      echo " - $key -> ${PATHS[$key]}"
    done
  fi
}
