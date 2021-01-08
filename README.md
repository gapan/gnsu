# About

gnsu allows a permitted user to execute a command with superuser privileges,
or as any other user. gnsu shows a graphical dialog requesting the user
password to allow the execution of the specified command.

As gnsu uses sudo as its backend, the password that you need to provide is
your current user's password, not the root user password. In any case, the
user name whose password you need to enter is shown in the gnsu graphical
dialog.

The user, or a group the user is part of, has to be allowed access to
launching applications using sudo. This can be accomplished by editing
the `/etc/sudoers` file using the `visudo` command. For example, adding
the following line somewhere in the /etc/sudoers file will allow user
george to run any command using sudo and by extension, gnsu:

```
george ALL=(ALL) ALL
```

Note that you can use any option that sudo has with gnsu, as gnsu passes all
arguments it is given to sudo. For example, you can use the sudo option -u to
run a command as another user, instead of running it as the superuser, which
is the default behaviour. Consult the sudo man page for more details about
those options.

HINT: symlinking gnsu to gksu/gksudo will allow you to use the gnsu in place
of those commands.

