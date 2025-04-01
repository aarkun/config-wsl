SSH_AGENT_ENV_FILE=~/.ssh/agent-env

if [ -z "$(pidof ssh-agent)" ]; then
    ssh-agent | head -n2 > $SSH_AGENT_ENV_FILE
fi
if [ -f $SSH_AGENT_ENV_FILE ]; then
    eval $(cat $SSH_AGENT_ENV_FILE)
fi
