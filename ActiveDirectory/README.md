# Remove Disabled Users from all AD Groups

## Summary

A lot of the time AD users get disabled but their group memberships are not cleaned up.

Use this script to find all disabled users in Active Directory and remove them from all the groups they're members of.

## Usage

Download the script and run it on a domain-joined machine with RSAT installed or on a domain controller.

You will see the following error in the shell for each user:

`Error is: 'The user cannot be removed from a group because the group is currently the user's primary group'`

This is normal. The script will not remove users from the `Domain Users` built-in security group. But it will remove them from all other groups.