Alterar informacoes do servico utilizado.


Exemplos:

Host bitbucket.org 
    HostName bitbucket.org
    PreferredAuthentications publickey
    IdentityFile /var/www/.ssh/id_rsa       ## Usuario Apache
    IdentityFile /var/lib/nginx/.ssh/id_rsa ## Usuario Nginx

ou


Host github.com
    HostName github.com
    PreferredAuthentications publickey
    IdentityFile /var/www/.ssh/id_rsa       ## Usuario Apache
    IdentityFile /var/lib/nginx/.ssh/id_rsa ## Usuario Nginx

Remova uma das linhas IdentityFile que nao corresponde ao usuario do servidor web
