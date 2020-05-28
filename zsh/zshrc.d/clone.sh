clone() {
    repo=$1

    if [ -z "$1" ]; then
        echo "Usage: clone <REPO URL>" 1>&2
        echo "Usage: clone <OWNER>/<REPONAME>" 1>&2
        return 1
    fi

    # Detect input types.
    if [[ $repo =~ "^\s*(ssh://)?git@ssh.dev.azure.com:v3/([a-zA-Z0-9\-_]+)/[a-zA-Z0-9\-_]+/([a-zA-Z0-9\-_\.]+)/?\s*$" ]]; then
        owner=$match[2]
        repoName=$match[3]
    elif [[ $repo =~ "^\s*(ssh://)?[A-Za-z]@vs-ssh.visualstudio.com:v3/([a-zA-Z0-9\-_]+)/[a-zA-Z0-9\-_]+/([a-zA-Z0-9\-_]+)/?\s*$" ]]; then
        owner=$match[2]
        repoName=$match[3]
    # It is important that '-' be first in the '[]'s below because that means it will be treated literally.
    elif [[ $repo =~ "^\s*([-a-zA-Z0-9_]+)/([-a-zA-Z0-9_]+)\s*$" ]]; then
        owner=$match[1]
        repoName=$match[2]
        repo="git@github.com:$owner/$repoName.git"
    elif [[ $repo =~ "^\s*(ssh://)git@github.com/([a-zA-Z0-9\-_]+)/([a-zA-Z0-9\-_\.]+)\.git/?\s*$" ]]; then
        owner=$match[2]
        repoName=$match[3]
    elif [[ $repo =~ "^\s*(ssh://)git@github.com/([a-zA-Z0-9\-_]+)/([a-zA-Z0-9\-_\.]+)/?\s*$" ]]; then
        owner=$match[2]
        repoName=$match[3]
    elif [[ $repo =~ "^\s*https://(www\.)?github.com/([a-zA-Z0-9\-_]+)/([a-zA-Z0-9\-_\.]+)\.git/?\s*$" ]]; then
        owner=$match[2]
        repoName=$match[3]
    elif [[ $repo =~ "^\s*https://(www\.)?github.com/([a-zA-Z0-9\-_]+)/([a-zA-Z0-9\-_\.]+)/?\s*$" ]]; then
        owner=$match[2]
        repoName=$match[3]
    else
        echo "This script can only be used with 'ssh://' URLs or GitHub owner/repo references" 1>&2
        return 1
    fi

    dest=~/code/$owner/$repoName

    if [ ! -d $dest ]; then
        echo "Cloning $repo into $dest"
        git clone $repo $dest
    fi

    cd "$dest"
}
