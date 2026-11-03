'use strict';

const express = require('express');

function createApp() {
  const app = express();
  app.disable('x-powered-by');
  app.use(express.json({ limit: '32kb', strict: true }));

  app.get('/health', (_request, response) => {
    response.status(200).json({ status: 'ok' });
  });

  app.get('/ready', (_request, response) => {
    response.status(200).json({ status: 'ready', ready: true });
  });

  app.use((_request, response) => {
    response.status(404).json({ error: { code: 'NOT_FOUND', message: 'Rota não encontrada.' } });
  });

  app.use((error, _request, response, _next) => {
    if (error instanceof SyntaxError && error.status === 400 && 'body' in error) {
      return response.status(400).json({ error: { code: 'INVALID_JSON', message: 'JSON inválido.' } });
    }
    if (error.type === 'entity.too.large') {
      return response.status(413).json({ error: { code: 'PAYLOAD_TOO_LARGE', message: 'Corpo da requisição excede o limite.' } });
    }
    console.error(JSON.stringify({ level: 'error', message: 'Falha não tratada na requisição.' }));
    return response.status(500).json({ error: { code: 'INTERNAL_ERROR', message: 'Erro interno.' } });
  });

  return app;
}

function start() {
  const host = process.env.HOST || '127.0.0.1';
  const port = Number(process.env.PORT || 3000);
  if (!Number.isInteger(port) || port < 1 || port > 65535) {
    throw new Error('PORT deve ser um inteiro entre 1 e 65535.');
  }

  const server = createApp().listen(port, host, () => {
    console.log(JSON.stringify({ level: 'info', event: 'server_started', host, port }));
  });

  const shutdown = (signal) => {
    server.close(() => {
      console.log(JSON.stringify({ level: 'info', event: 'server_stopped', signal }));
      process.exit(0);
    });
    setTimeout(() => process.exit(1), 10_000).unref();
  };
  process.on('SIGINT', () => shutdown('SIGINT'));
  process.on('SIGTERM', () => shutdown('SIGTERM'));
  return server;
}

if (require.main === module) start();

module.exports = { createApp, start };
