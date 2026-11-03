'use strict';

const { test } = require('node:test');
const assert = require('node:assert/strict');
const { createApp } = require('../apps/termux-api/server');

async function withServer(run) {
  const server = createApp().listen(0, '127.0.0.1');
  await new Promise((resolve) => server.once('listening', resolve));
  try {
    const address = server.address();
    await run(`http://127.0.0.1:${address.port}`);
  } finally {
    await new Promise((resolve, reject) => server.close((error) => error ? reject(error) : resolve()));
  }
}

test('GET /health retorna estado de saúde sem dados sensíveis', async () => {
  await withServer(async (baseUrl) => {
    const response = await fetch(`${baseUrl}/health`);
    assert.equal(response.status, 200);
    assert.deepEqual(await response.json(), { status: 'ok' });
    assert.equal(response.headers.get('x-powered-by'), null);
  });
});

test('GET /ready retorna prontidão da API', async () => {
  await withServer(async (baseUrl) => {
    const response = await fetch(`${baseUrl}/ready`);
    assert.equal(response.status, 200);
    assert.deepEqual(await response.json(), { status: 'ready', ready: true });
  });
});

test('rota desconhecida retorna erro JSON estável', async () => {
  await withServer(async (baseUrl) => {
    const response = await fetch(`${baseUrl}/inexistente`);
    assert.equal(response.status, 404);
    assert.deepEqual(await response.json(), {
      error: { code: 'NOT_FOUND', message: 'Rota não encontrada.' },
    });
  });
});
