import subprocess

while True:
    print("0 Init AWS configuration")
    print("1 Create VPN node on AWS")
    print("2 Check the status of VPN server on AWS")
    print("3 Remove the existing VPN server from AWS")
    print("4 Exit vpn-launchpad")
    print("")

    choice = input ('Please select:    ')

    if choice == 0:
        print("Init AWS configuration")
        print("Please visit http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-quick-configuration")
        print("to initialize your credential")
        print("")
        subprocess.call(["aws", "configure"])
    elif choice == 1:
        print("Create VPN node on AWS")
        print("")
        subprocess.call(["../vlp-build"])
    elif choice == 2:
        print("Check the status of VPN server on AWS")
        print("")
        subprocess.call(["../vlp-query"])
    elif choice == 3:
        print("Remove the existing VPN server from AWS")
        print("")
        subprocess.call(["../vlp-purge"])
    elif choice == 4:
        print("Exit vpn-launchpad")
        print("")
        break;
    else:
        pass
