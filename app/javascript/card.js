const initializePayjs = () => {
  const cardNumberElement = document.getElementById("card-number-element");
  // カード入力欄がないページでは何もしない
  if (!cardNumberElement) return;

  // Turbo遷移で再初期化しない
  if (cardNumberElement.children.length > 0) return;

  const publicKey = document
    .querySelector('meta[name="payjp-public-key"]')
    ?.getAttribute("content");

  if (!publicKey) {
    console.error("Public key not found");
    return;
  }

  const payjp = Payjp(publicKey);
  const elements = payjp.elements();

  const cardNumber = elements.create("cardNumber");
  const cardExpiry = elements.create("cardExpiry");
  const cardCvc = elements.create("cardCvc");

  cardNumber.mount("#card-number-element");
  cardExpiry.mount("#card-expiry-element");
  cardCvc.mount("#card-cvc-element");

  const form = document.getElementById("charge-form");
  if (!form) return;

  form.addEventListener("submit", async (e) => {
    e.preventDefault();

    const result = await payjp.createToken(cardNumber);

    // エラー処理
    if (result.error) {
      alert(result.error.message);
      return;
    }

    const tokenId = result.id;

    if (!tokenId) {
      alert("決済トークンの取得に失敗しました");
      return;
    }

    // hidden input 作成
    const hidden = document.createElement("input");
    hidden.type = "hidden";
    hidden.name = "token";
    hidden.value = tokenId; // ← token ではなく tokenId
    form.appendChild(hidden);

    form.submit();
  });
};

// 初回読み込み・リンク遷移時
document.addEventListener("turbo:load", initializePayjs);

// バリデーションエラーなどの再レンダリング時
document.addEventListener("turbo:render", initializePayjs);