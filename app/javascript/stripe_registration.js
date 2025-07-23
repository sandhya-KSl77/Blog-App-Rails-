document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("new_user") || document.getElementById("registration-form");
    const planSelect = document.querySelector("select[name='user[plan]']");
    const cardSection = document.getElementById("card-section");
    const stripeTokenField = document.getElementById("stripe-token");
  
    if (!form || !planSelect || !stripeTokenField) return;
  
    const stripe = Stripe(document.querySelector("meta[name='stripe-public-key']").content);
    const elements = stripe.elements();
    const cardElement = elements.create("card");
    cardElement.mount("#card-element");
  
    // Show/hide card section based on plan
    planSelect.addEventListener("change", function () {
      cardSection.style.display = planSelect.value ? "block" : "none";
    });
  
    cardElement.on("change", function (event) {
      const errorDiv = document.getElementById("card-errors");
      errorDiv.textContent = event.error ? event.error.message : "";
    });
  
    form.addEventListener("submit", async function (event) {
      if (planSelect.value !== "") {
        event.preventDefault();
  
        const { token, error } = await stripe.createToken(cardElement);
  
        if (error) {
          document.getElementById("card-errors").textContent = error.message;
        } else {
          stripeTokenField.value = token.id;
          form.submit();
        }
      }
    });
  });
  