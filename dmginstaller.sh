#!/bin/bash

set -e

usage (){
    echo "Usage: sh install --[options] [url]"
    echo "Options: "
    echo " -mp | --mac-plugin   : Install a mac Internet plugin from dmg file."
    echo " -ma | --mac-app      : Install a mac app from dmg file."
    echo " -l  | --linux-plugin : Install a mozilla linux plugin from tar.gz file."
    echo " -h  | --help         : Show help."
}

if [[ $# -lt 2 ]]; then
  usage
  exit 1
else
    url=$2;
    plugin_dir="";
fi


download_and_install_linux(){
    dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    # Generate a random file name
    tmp_file=/tmp/`openssl rand -base64 10 | tr -dc '[:alnum:]'`.tar.gz
    tmp_dir=`mktemp -d`

    # check if tmp dir was created
    if [[ ! "$tmp_dir" || ! -d "$tmp_dir" ]]; then
      echo "Could not create temp dir : $tmp_dir"
      exit 1
    fi

    mozilla_dir=~/.mozilla/;
    if [ ! -d "$mozilla_dir" ]; then
        mkdir "$mozilla_dir";
    fi
    plugin_dir=~/.mozilla/plugins/;
    if [ ! -d "$plugin_dir" ]; then
        mkdir "$plugin_dir";
    fi

    # Download file
    echo "Downloading $url..."
    curl -# -L -o ${tmp_file} ${url}

    # Unzip the file in the temp dir
    tar -xvf ${tmp_file} -C ${tmp_dir}

    cd ${tmp_dir}
    echo "Installing plugin at ${tmp_dir}"
    cp npSigniantTransfer*.so ~/.mozilla/plugins/

    #Clean up
    rm ${tmp_file}
    rm -rf ${tmp_dir}

    echo ${success_msg}
}

download_and_install_mac() {
    # Generate a random file name
    tmp_file=/tmp/`openssl rand -base64 10 | tr -dc '[:alnum:]'`.dmg

    # Download file
    echo "Downloading $url..."
    curl -# -L -o ${tmp_file} ${url}
    echo "Mounting image..."
    volume=`hdiutil mount ${tmp_file} | tail -n1 | perl -nle '/(\/Volumes\/[^ ]+)/; print $1'`

    # Locate .app folder and move to /Applications
    app=`find ${volume} -regex ".*.\(app\)" -maxdepth 1  -type d -print0`

    if [ "$plugin_dir" == "true" ]; then
        app=`find "${app}" -regex ".*.\(plugin\)" -maxdepth 3  -type d -print0`
    fi

    if [ ! -d "$out_dir" ]; then
        echo "Sorry $out_dir directory not found";
        exit 1;
    else
        echo "Copying `echo ${app} | awk -F/ '{print $NF}'` into $out_dir..."
        cp -r "${app}" "${out_dir}"
    fi
    ## Unmount volume, delete temporary file
    echo "Cleaning up..."
    hdiutil unmount ${volume} -quiet
    rm ${tmp_file}
    echo ${success_msg}

}


while [[ $# -gt 1 ]]
do
option="$1"
case ${option} in
    -h| --help)
    usage
    ;;
    -l|--linux-plugin)
    success_msg='Plugin installed successfully'
    download_and_install_linux
    shift;;
    -ma|--mac-app)
    out_dir="/Applications"
    success_msg='App installed successfully'
    download_and_install_mac
    shift;;
    -mp|--mac-plugin)
    out_dir="$HOME/Library/Internet Plug-Ins"
    plugin_dir="true"
    success_msg='Plugin installed successfully'
    download_and_install_mac
    shift;;
    *)
    echo "Unknown option '$option'"
    ;;
esac
done

