// Caddygate 営業資料用スクリーンショット取得
// 使い方:
//   1. seed-demo-data.sql を Supabase で実行済み
//   2. demo 用ゴルフ場アカウント (caddygate-demo@gmail.com) で Web 上に signup 済み (email+password)
//   3. .env に DEMO_EMAIL=... DEMO_PASSWORD=... を入れる、または下記定数に直接書く
//   4. node capture-screenshots.js
//
// 出力先: ./assets/screenshots/{name}.png

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const BASE_URL = process.env.BASE_URL || 'https://golf-caddy.pages.dev';
const DEMO_EMAIL = process.env.DEMO_EMAIL || 'caddygate-demo@gmail.com';
const DEMO_PASSWORD = process.env.DEMO_PASSWORD || 'CaddygateDemo2026!';

const OUT_DIR = path.join(__dirname, 'assets', 'screenshots');
fs.mkdirSync(OUT_DIR, { recursive: true });

const VIEWPORT_PC = { width: 1440, height: 900 };
const VIEWPORT_MOBILE = { width: 390, height: 844 };

async function screenshot(page, name, fullPage = false) {
  const out = path.join(OUT_DIR, `${name}.png`);
  await page.screenshot({ path: out, fullPage });
  console.log(`✓ ${name}.png (fullPage=${fullPage})`);
}

async function loginGolf(page) {
  await page.goto(`${BASE_URL}/login/?role=golf`);
  await page.waitForLoadState('networkidle');
  await page.fill('#email', DEMO_EMAIL);
  await page.fill('#pass', DEMO_PASSWORD);
  await page.click('#submitBtn');
  // role 判定済みダッシュボードへ
  await page.waitForURL(/golf_dashboard|dashboard/, { timeout: 30000 });
  await page.waitForLoadState('networkidle');
}

async function captureGolfDashboard() {
  const browser = await chromium.launch({ headless: true });
  const ctx = await browser.newContext({ viewport: VIEWPORT_PC, deviceScaleFactor: 2 });
  const page = await ctx.newPage();

  try {
    // 1. LP
    await page.goto(`${BASE_URL}/`);
    await page.waitForLoadState('networkidle');
    await screenshot(page, '01-lp-top', false);

    // 2. ログイン画面
    await page.goto(`${BASE_URL}/login/?role=golf`);
    await page.waitForLoadState('networkidle');
    await screenshot(page, '02-login-golf', false);

    // 3. ログイン後 → ゴルフ場ダッシュボード
    await loginGolf(page);
    await page.waitForTimeout(2500);
    await screenshot(page, '03-golf-dashboard-prof', false);

    // 4. プロフィール (基本情報サブタブ)
    await page.click('text=プロフィール').catch(() => {});
    await page.waitForTimeout(1500);
    await screenshot(page, '04-golf-profile', true);

    // 5. キャディを探す (空き日付から)
    const searchBtn = page.locator('[id*=NavSearch], [id*=navSearch], text=キャディを探す').first();
    await searchBtn.click({ timeout: 5000 }).catch(() => {});
    await page.waitForTimeout(2500);
    await screenshot(page, '05-golf-search-by-date', false);

    // 6. 予約状況
    const reservBtn = page.locator('text=予約状況, [id*=Reserve], [id*=Reservation]').first();
    await reservBtn.click({ timeout: 5000 }).catch(() => {});
    await page.waitForTimeout(2500);
    await screenshot(page, '06-golf-reservations', false);

    // 7. 研修管理
    const trainBtn = page.locator('text=研修管理, [id*=Training]').first();
    await trainBtn.click({ timeout: 5000 }).catch(() => {});
    await page.waitForTimeout(1500);
    await screenshot(page, '07-golf-training', false);

    // 8. モバイル view: トップ
    await page.setViewportSize(VIEWPORT_MOBILE);
    await page.goto(`${BASE_URL}/`);
    await page.waitForLoadState('networkidle');
    await screenshot(page, '08-mobile-lp', false);

    // 9. モバイル view: ゴルフ場ダッシュボード
    await page.goto(`${BASE_URL}/golf_dashboard.html`);
    await page.waitForTimeout(2500);
    await screenshot(page, '09-mobile-golf-dashboard', false);

  } catch (e) {
    console.error('screenshot 失敗:', e.message);
  } finally {
    await browser.close();
  }
}

(async () => {
  console.log(`\n== Caddygate 営業資料 スクリーンショット撮影 ==`);
  console.log(`BASE_URL: ${BASE_URL}`);
  console.log(`DEMO_EMAIL: ${DEMO_EMAIL}`);
  console.log(`出力先: ${OUT_DIR}\n`);

  await captureGolfDashboard();
  console.log('\n完了。出力ファイル一覧:');
  fs.readdirSync(OUT_DIR).filter(f => f.endsWith('.png')).forEach(f => console.log('  -', f));
})();
