export const GHOST_CONFIG = {
    TCP_PORT: 9999,
    TRIGGER_PHRASE: 'GHOST_READY',
    DEFAULT_HOST: process.env.GHOST_HOST || 'host.docker.internal' 
};
