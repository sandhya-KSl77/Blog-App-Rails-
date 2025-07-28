document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("subscription-form");
  const stripeTokenField = document.getElementById("stripe-token");

  if (!form || !stripeTokenField) return;

  const stripe = Stripe(document.querySelector("meta[name='stripe-public-key']").content);
  const elements = stripe.elements();
  const cardElement = elements.create("card");
  cardElement.mount("#card-element");

  cardElement.on("change", function (event) {
    const errorDiv = document.getElementById("card-errors");
    errorDiv.textContent = event.error ? event.error.message : "";
  });

  form.addEventListener("submit", async function (event) {
    event.preventDefault();

    const { token, error } = await stripe.createToken(cardElement);

    if (error) {
      document.getElementById("card-errors").textContent = error.message;
    } else {
      stripeTokenField.value = token.id;
      form.submit();
    }
  });
});
