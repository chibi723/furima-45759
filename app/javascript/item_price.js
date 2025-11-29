const setupPriceCalc = () => {
  const priceInput  = document.getElementById("item-price");
  const taxField    = document.getElementById("add-tax-price");
  const profitField = document.getElementById("profit");

  if (!priceInput || !taxField || !profitField) return;

  priceInput.addEventListener("input", () => {
    const price = parseInt(priceInput.value, 10);

    if (Number.isNaN(price)) {
      taxField.textContent    = "";
      profitField.textContent = "";
      return;
    }

    const tax    = Math.floor(price * 0.1); // 10%
    const profit = price - tax;

    taxField.textContent    = tax.toLocaleString();
    profitField.textContent = profit.toLocaleString();
  });
};

// Rails 7 + Turbo 対応
document.addEventListener("turbo:load",   setupPriceCalc);
document.addEventListener("turbo:render", setupPriceCalc);
