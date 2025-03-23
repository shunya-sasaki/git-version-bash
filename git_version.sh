#!/bin/bash
set -e

trap catch ERR
trap finally EXIT

function catch {
    echo "ERROR: Stop the process!"
    exit 1
}

function finally {
    exit 0
}

function get_version {
    branch=$(git rev-parse --abbrev-ref HEAD)
    last_tag=$(git describe --tags --abbrev=0)
    commit_count=$(git rev-list ${last_tag}..HEAD --count)
    current_hash=$(git rev-parse --short HEAD)
    version_nums=$(echo ${last_tag} | tr -d 'v')
    major=$(echo ${version_nums} | cut -d. -f1)
    minor=$(echo ${version_nums} | cut -d. -f2)
    patch=$(echo ${version_nums} | cut -d. -f3)
    changes=$(git status -s)
    if [ -z "${changes}" ]; then
        is_change=false
    else
        is_change=true
    fi
    if [ ${commit_count} -eq 0 ]; then
        if [ ${is_change} = true ]; then
            patch=$((patch + 1))
            version="${major}.${minor}.${patch}.dev${commit_count}+d${current_hash}"
        else
            version="${major}.${minor}.${patch}"
        fi
    else
        patch=$((patch + 1))
        version="${major}.${minor}.${patch}.dev${commit_count}+d${current_hash}"
    fi
    echo ${version}
}

function release {
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [ ${current_branch} != "main" ]; then
        echo "ERROR: You must be on the main branch!"
        exit 1
    fi
    last_tag=$(git describe --tags --abbrev=0)
    commit_message=$(git log -1 --pretty=%B)
    if [[ ${commit_message} == "Release ${last_tag}" ]]; then
        echo "ERROR: You have already released the latest version!"
        exit 1
    fi
    commit_count=$(git rev-list ${last_tag}..HEAD --count)
    if [ ${commit_count} -ne 0 ]; then
        echo "ERROR: There are some changes from the last tag!"
        echo "Please tag the last commit before release!"
        exit 1
    fi
    git tag -d ${last_tag}
    git commit --allow-empty -m "Release ${last_tag}"
    git tag -a ${last_tag} -m "Release ${last_tag}"
    git push origin --tags
    git push origin main
}

version=$(get_version)
release
