# iOS Paywall & In-App Purchase — cơ chế end-to-end

> Level: 3/5 · Last coached: 2026-07-30 · Next review: 2026-08-02

## System explanation

**Đường mua (purchase path):** App gọi StoreKit (`Product.purchase()`) → **OS vẽ payment sheet**, app không bao giờ chạm vào thông tin thẻ. StoreKit kết nối App Store thay mặt app, xử lý thanh toán. **BE không nằm trong đường mua.** App Store trả về app một **Transaction ký số dạng JWS** (JSON Web Signature — Apple ký, client verify được, không giả mạo được).

**Neo quyền sở hữu = Apple ID**, không phải device ID, không phải account app. Apple làm transaction khả dụng "on all of the customer's devices" — user xóa app, đổi iPhone, miễn đăng nhập cùng Apple ID là quyền quay lại (nút **Restore Purchases** — App Store bắt buộc phải có khi bán IAP). Hệ quả: app không có hệ thống login vẫn giữ sub qua đổi máy bình thường; đừng tự chế neo device-id.

**App mở khóa:** đọc `Transaction.currentEntitlements` từ StoreKit, verify chữ ký JWS on-device. App đơn giản không cần BE.

**BE (tùy chọn) — trust model:** không bao giờ tin transaction client gửi lên (client jailbreak fake được). App gửi transaction → BE **verify lại với App Store Server API** → mới grant entitlement vào account app. Muốn BE biết sự kiện vòng đời phải đăng ký **App Store Server Notifications v2** (URL webhook trong App Store Connect): Apple POST các event renew, cancel, billing thất bại, grace period, refund. Không đăng ký thì BE điếc — App Store KHÔNG tự báo.

**Dòng tiền:** user → Apple charge phương thức thanh toán của Apple ID → Apple giữ commission ~15–30% (15% Small Business Program <$1M/năm; subscription từ năm 2) ⚠️ → payout cho dev theo chu kỳ ~tháng ⚠️. Chính sách đang biến động (Epic ruling ở Mỹ cho external link, EU DMA) — check lại khi làm pricing.

**Paywall UI:** guideline 3.1.1 — digital goods phải dùng IAP (carve-out Mỹ/EU đang thay đổi ⚠️); paywall phải hiện giá + kỳ hạn rõ, có Restore, link Terms/Privacy với subscription.

## Edge cases & trade-offs

- **Refund:** Apple revoke entitlement, BE biết qua notification REFUND / `revocationDate` — phải xử lý thu hồi quyền.
- **Grace period / billing retry:** thanh toán renew thất bại nhưng entitlement giữ thêm một khoảng — đừng cắt quyền ngay khi hết hạn danh nghĩa.
- **Cross-platform:** neo Apple ID chỉ sống trong hệ Apple; muốn sub dùng chung iOS/Android/web thì bắt buộc có account riêng của app (đây mới là lý do thật để làm login, không phải để "giữ sub khi đổi iPhone").
- **Family Sharing:** subscription có thể share trong gia đình nếu bật — entitlement xuất hiện trên Apple ID khác.
- **Sandbox ≠ production:** test bằng sandbox account/StoreKit config file trong Xcode; thời gian renew rút ngắn.

## Past gaps

Re-checked OK 2026-07-30 (giải thích lại đúng cả hai):
- Tưởng app không login thì sub neo device-id, đổi máy là mất → thật ra neo Apple ID + Restore Purchases.
- Thiếu trust model: BE phải verify transaction với Apple vì client fake được.

Chưa re-check:
- App Store → BE không tự động — phải đăng ký webhook Server Notifications v2.
- Con số commission + chính sách anti-steering hiện hành (⚠️ chưa verify nguồn).
