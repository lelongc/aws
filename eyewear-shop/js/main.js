$(document).ready(function () {
  // Initialize tooltips
  var tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
  );
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });

  // Initialize toasts
  var toastElList = [].slice.call(document.querySelectorAll(".toast"));
  var toastList = toastElList.map(function (toastEl) {
    return new bootstrap.Toast(toastEl);
  });

  // Cart functionality
  let cart = JSON.parse(localStorage.getItem("cart")) || [];
  let wishlist = JSON.parse(localStorage.getItem("wishlist")) || [];
  updateCartCount();

  // Check if product is in wishlist
  if ($(".product-detail-page").length) {
    const productId = $("#add-to-cart-btn").data("id");
    if (wishlist.includes(parseInt(productId))) {
      $("#add-to-wishlist-btn").addClass("active");
      $("#add-to-wishlist-btn i").removeClass("far").addClass("fas");
    }
  }

  // Add to cart with enhanced functionality
  $(".add-to-cart").on("click", function () {
    const button = $(this);
    const originalText = button.html();

    // Show loading state
    button.html(
      '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Adding...'
    );
    button.prop("disabled", true);

    setTimeout(function () {
      const id = button.data("id");
      const name = button.data("name");
      const price = parseFloat($("#product-price").text());
      const quantity = parseInt($("#quantity").val()) || 1;
      const color = $(".selected-color span").text();
      const size = $(".selected-size span").text();
      const lensType = $("#lens-type option:selected").text();

      // Check if product is already in cart
      const existingItemIndex = cart.findIndex(
        (item) =>
          item.id === id &&
          item.color === color &&
          item.size === size &&
          item.lensType === lensType
      );

      if (existingItemIndex !== -1) {
        cart[existingItemIndex].quantity += quantity;
      } else {
        cart.push({
          id: id,
          name: name,
          price: price,
          quantity: quantity,
          color: color,
          size: size,
          lensType: lensType,
          image: $("#main-product-image").attr("src"),
        });
      }

      // Save to local storage with error handling
      try {
        localStorage.setItem("cart", JSON.stringify(cart));
        updateCartCount();

        // Show success toast
        const toast = new bootstrap.Toast(
          document.getElementById("productAddedToast")
        );
        toast.show();

        // Reset button state
        button.html(originalText);
        button.prop("disabled", false);
      } catch (error) {
        console.error("Failed to save cart to localStorage:", error);
        alert("Failed to add item to cart. Please try again.");
        button.html(originalText);
        button.prop("disabled", false);
      }
    }, 800); // Simulate network request
  });

  // Update cart count
  function updateCartCount() {
    const totalItems = cart.reduce((total, item) => total + item.quantity, 0);
    $(".cart-count").text(totalItems);

    // Animate the cart icon if items count increased
    if (totalItems > 0) {
      $(".cart-count").addClass("pulse");
      setTimeout(() => {
        $(".cart-count").removeClass("pulse");
      }, 1000);
    }
  }

  // Show notification
  function showNotification(message, type = "success") {
    // Create notification element if it doesn't exist
    if ($("#notification").length === 0) {
      $("body").append(
        '<div id="notification" class="toast-notification"></div>'
      );
    }

    // Apply appropriate styling based on notification type
    $("#notification").removeClass("success error warning");
    $("#notification").addClass(type);

    // Show notification
    $("#notification").text(message).addClass("show");

    // Hide after 3 seconds
    setTimeout(() => {
      $("#notification").removeClass("show");
    }, 3000);
  }

  // Product detail page functionality
  if ($(".product-detail-page").length) {
    // Image gallery thumbnails
    $(".thumbnail").on("click", function () {
      const newSrc = $(this).data("img");
      $("#main-product-image").fadeOut(150, function () {
        $(this).attr("src", newSrc).fadeIn(150);
      });

      // Update active thumbnail
      $(".thumbnail").removeClass("active-thumbnail");
      $(this).addClass("active-thumbnail");
    });

    // Color selection with image update
    $(".color-option").on("click", function () {
      // Remove active class from all colors
      $(".color-option").removeClass("active");

      // Add active class to clicked color
      $(this).addClass("active");

      // Update color text
      const selectedColor = $(this).data("color");
      $(".selected-color span").text(selectedColor);

      // Update product image if color has associated image
      const colorImg = $(this).data("img");
      if (colorImg) {
        $("#main-product-image").fadeOut(150, function () {
          $(this).attr("src", colorImg).fadeIn(150);
        });
      }
    });

    // Size selection
    $(".size-option").on("click", function () {
      $(".size-option").removeClass("active");
      $(this).addClass("active");

      // Update size text
      const selectedSize = $(this).data("size");
      let sizeText;
      switch (selectedSize) {
        case "S":
          sizeText = "Small";
          break;
        case "M":
          sizeText = "Medium";
          break;
        case "L":
          sizeText = "Large";
          break;
        case "XL":
          sizeText = "Extra Large";
          break;
        default:
          sizeText = selectedSize;
      }
      $(".selected-size span").text(sizeText);
    });

    // Lens type selection with price update
    $("#lens-type").on("change", function () {
      const basePrice = 95; // Base product price
      const lensUpcharge = parseFloat($(this).val());
      const newPrice = basePrice + lensUpcharge;

      // Animate price change
      $({ price: parseFloat($("#product-price").text()) }).animate(
        { price: newPrice },
        {
          duration: 300,
          step: function () {
            $("#product-price").text(this.price.toFixed(2));
          },
          complete: function () {
            $("#product-price").text(newPrice.toFixed(2));
          },
        }
      );
    });

    // Quantity adjustment
    $(".quantity-btn").on("click", function () {
      let quantity = parseInt($("#quantity").val());
      const max = parseInt($("#quantity").attr("max")) || 10;

      if ($(this).hasClass("decrease")) {
        if (quantity > 1) quantity--;
      } else {
        if (quantity < max) quantity++;
      }

      $("#quantity").val(quantity);
    });

    // Validate quantity input
    $("#quantity").on("input", function () {
      let value = $(this).val();

      // Remove non-numeric characters
      value = value.replace(/[^0-9]/g, "");

      // Ensure it's between min and max
      const min = parseInt($(this).attr("min")) || 1;
      const max = parseInt($(this).attr("max")) || 10;

      if (value === "" || parseInt(value) < min) {
        value = min;
      } else if (parseInt(value) > max) {
        value = max;
      }

      $(this).val(value);
    });

    // Enhanced wishlist functionality
    $("#add-to-wishlist-btn").on("click", function () {
      // Check if user is logged in
      if (!isLoggedIn) {
        showNotification(
          "Please login to add items to your wishlist",
          "warning"
        );
        setTimeout(() => {
          window.location.href = "login.html";
        }, 1500);
        return;
      }

      const productId = parseInt($("#add-to-cart-btn").data("id")); // Ensure ID is integer
      const productName = $("#add-to-cart-btn").data("name");
      const productPrice = parseFloat($("#product-price").text());
      const productImage = $("#main-product-image").attr("src");
      const productColor = $(".selected-color span").text();
      const productSize = $(".selected-size span").text();

      if ($(this).hasClass("active")) {
        // Remove from wishlist
        wishlist = wishlist.filter((item) => item.id !== productId);
        $(this).removeClass("active");
        $(this).html('<i class="far fa-heart me-2"></i> Add to Wishlist');
        showNotification("Removed from your wishlist", "warning");
      } else {
        // Add to wishlist (store more details)
        if (!wishlist.some((item) => item.id === productId)) {
          wishlist.push({
            id: productId,
            name: productName,
            price: productPrice,
            image: productImage,
            color: productColor,
            size: productSize,
            dateAdded: new Date().toISOString(),
          });
        }
        $(this).addClass("active");
        $(this).html('<i class="fas fa-heart me-2"></i> Added to Wishlist');
        showNotification("Added to your wishlist", "success");
      }

      localStorage.setItem("wishlist", JSON.stringify(wishlist));
    });

    // Virtual try-on button
    $("#try-on-btn").on("click", function () {
      const tryOnModal = new bootstrap.Modal(
        document.getElementById("tryOnModal")
      );
      tryOnModal.show();
    });

    // Virtual try-on color selection
    $("#tryOnModal .color-option").on("click", function () {
      $("#tryOnModal .color-option").removeClass("active");
      $(this).addClass("active");

      const overlayImg = $(this).data("overlay");
      $("#glasses-overlay").attr("src", overlayImg);
    });

    // Face model selection
    $("#face-model-select").on("change", function () {
      const modelImg = $(this).val();
      $("#face-model").attr("src", modelImg);
    });

    // Save try-on image
    $("#save-try-on").on("click", function () {
      alert(
        "This feature would capture the current try-on image and allow saving. In a real implementation, it would use html2canvas or a similar library to capture the composite image."
      );
    });

    // Initialize image zoom
    $(".zoom-gallery-btn").on("click", function (e) {
      e.preventDefault();
      const imgSrc = $("#main-product-image").attr("src");

      $("<div>").addClass("zoom-overlay").appendTo("body");

      $("<img>")
        .attr("src", imgSrc)
        .addClass("zoomed-image")
        .appendTo("body")
        .on("click", function () {
          $(".zoom-overlay, .zoomed-image").remove();
        });

      $(".zoom-overlay").on("click", function () {
        $(".zoom-overlay, .zoomed-image").remove();
      });
    });

    // Share product functionality
    $(".share-btn").on("click", function () {
      const platform = $(this).data("platform");
      const productUrl = window.location.href;
      const productTitle = $("h2.fw-bold").text();

      let shareUrl;
      switch (platform) {
        case "facebook":
          shareUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(
            productUrl
          )}`;
          break;
        case "twitter":
          shareUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(
            productTitle
          )}&url=${encodeURIComponent(productUrl)}`;
          break;
        case "pinterest":
          const imageUrl = $("#main-product-image").attr("src");
          shareUrl = `https://pinterest.com/pin/create/button/?url=${encodeURIComponent(
            productUrl
          )}&media=${encodeURIComponent(
            imageUrl
          )}&description=${encodeURIComponent(productTitle)}`;
          break;
      }

      window.open(shareUrl, "_blank", "width=600,height=400");
    });

    // Product reviews functionality
    loadProductReviews();

    // More Reviews button
    $(".btn-more-reviews").on("click", function () {
      const moreReviews = $(".hidden-review");
      moreReviews.slideDown();
      $(this).hide();
    });
  }

  // Load product reviews
  function loadProductReviews() {
    if ($("#reviews").length) {
      const productId = parseInt($("#add-to-cart-btn").data("id"));

      // In a real app, you'd fetch reviews from a server
      // Simulate loading reviews
      setTimeout(function () {
        const reviews =
          JSON.parse(localStorage.getItem("productReviews")) || {};
        const productReviews = reviews[productId] || [];

        // Update reviews tab count
        const reviewCount = productReviews.length + 3; // 3 default reviews
        $("#reviews-tab").text(`Reviews (${reviewCount})`);

        // Display loaded reviews (append after the default ones)
        const reviewsContainer = $("#reviews .mb-4"); // Target the container holding reviews
        reviewsContainer.find(".user-review").remove(); // Clear previously loaded reviews

        productReviews.forEach((review) => {
          reviewsContainer.append(`
            <div class="d-flex mb-3 border-bottom pb-3 user-review">
              <img src="https://via.placeholder.com/50?text=${review.userName.charAt(
                0
              )}" alt="Reviewer Avatar" class="rounded-circle me-3" style="width: 50px; height: 50px;">
              <div>
                <div class="d-flex justify-content-between align-items-center">
                  <h6 class="mb-0">${review.userName}</h6>
                  <span class="text-muted small">${new Date(
                    review.date
                  ).toLocaleDateString()}</span>
                </div>
                <div class="text-warning mb-1">
                  ${'<i class="fas fa-star"></i>'.repeat(review.rating)}
                  ${'<i class="far fa-star"></i>'.repeat(5 - review.rating)}
                </div>
                <p class="mb-0">${review.text}</p>
              </div>
            </div>
          `);
        });
      }, 500);
    }
  }

  // Product review submission
  $("#reviewForm").on("submit", function (e) {
    e.preventDefault();

    if (!isLoggedIn) {
      showNotification("Please login to submit a review", "warning");
      setTimeout(() => {
        window.location.href = "login.html";
      }, 1500);
      return;
    }

    const rating = parseInt($("input[name='rating']:checked").val());
    const reviewText = $("#reviewText").val().trim();
    const productId = parseInt($("#add-to-cart-btn").data("id"));

    if (!rating) {
      showNotification("Please select a rating", "warning");
      return;
    }

    if (!reviewText) {
      showNotification("Please write a review", "warning");
      return;
    }

    // Simulate submitting the review
    $(this)
      .find("button[type='submit']")
      .html(
        '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Submitting...'
      )
      .prop("disabled", true);

    setTimeout(() => {
      const newReview = {
        id: Date.now().toString(),
        productId: productId,
        userId: currentUser.id,
        userName: currentUser.name,
        rating: rating,
        text: reviewText,
        date: new Date().toISOString(),
      };

      // Store review in localStorage
      const reviews = JSON.parse(localStorage.getItem("productReviews")) || {};
      if (!reviews[productId]) {
        reviews[productId] = [];
      }

      reviews[productId].push(newReview);
      localStorage.setItem("productReviews", JSON.stringify(reviews));

      // Reset form
      $(this)[0].reset();
      $(this)
        .find("button[type='submit']")
        .html("Submit Review")
        .prop("disabled", false);

      showNotification("Thank you for your review!", "success");

      // Reload reviews
      loadProductReviews();
    }, 1000);
  });

  // Cart page functionality
  if ($(".cart-page").length) {
    displayCartItems();

    // Update quantity
    $(document).on("click", ".quantity-btn", function () {
      const id = $(this).closest(".cart-item").data("id");
      const action = $(this).hasClass("decrease") ? "decrease" : "increase";

      updateItemQuantity(id, action);
    });

    // Remove from cart
    $(document).on("click", ".remove-item", function () {
      const id = $(this).closest(".cart-item").data("id");
      const row = $(this).closest(".cart-item");

      // Animate removal
      row.addClass("removing");
      setTimeout(() => {
        removeItemFromCart(id);
      }, 300);
    });

    // Display cart items
    function displayCartItems() {
      const cartContainer = $(".cart-items");
      cartContainer.empty();

      if (cart.length === 0) {
        cartContainer.append(
          `<div class="text-center py-5">
            <div class="empty-cart-icon mb-3">
              <i class="fas fa-shopping-cart fa-4x text-muted"></i>
            </div>
            <h4>Your cart is empty</h4>
            <p class="text-muted">Looks like you haven't added any items to your cart yet.</p>
            <a href="products.html" class="btn btn-primary mt-3">Continue Shopping</a>
          </div>`
        );
        $(".cart-summary").hide();
        return;
      }

      let totalPrice = 0;

      cart.forEach((item) => {
        const itemTotal = item.price * item.quantity;
        totalPrice += itemTotal;

        cartContainer.append(`
          <div class="cart-item" data-id="${item.id}">
            <div class="row align-items-center">
              <div class="col-md-2">
                <img src="${
                  item.image ||
                  "https://via.placeholder.com/100x70?text=Product"
                }" class="img-fluid rounded" alt="${item.name}">
              </div>
              <div class="col-md-4">
                <h5>${item.name}</h5>
                <p class="text-muted mb-0">
                  ${item.color ? "Color: " + item.color : ""}
                  ${item.size ? " | Size: " + item.size : ""}
                </p>
                <p class="text-muted">${item.lensType || "Standard Lens"}</p>
              </div>
              <div class="col-md-2">
                <p class="fw-bold">$${item.price.toFixed(2)}</p>
              </div>
              <div class="col-md-2">
                <div class="quantity-selector">
                  <button class="btn btn-sm btn-outline-secondary quantity-btn decrease">-</button>
                  <input type="text" class="form-control mx-1" value="${
                    item.quantity
                  }" readonly>
                  <button class="btn btn-sm btn-outline-secondary quantity-btn increase">+</button>
                </div>
              </div>
              <div class="col-md-1">
                <p class="fw-bold">$${itemTotal.toFixed(2)}</p>
              </div>
              <div class="col-md-1 text-end">
                <button class="btn btn-sm btn-link text-danger remove-item">
                  <i class="fas fa-trash"></i>
                </button>
              </div>
            </div>
          </div>
        `);
      });

      // Update cart summary
      $(".subtotal-value").text("$" + totalPrice.toFixed(2));

      const shipping = totalPrice >= 100 ? 0 : 10;
      $(".shipping-value").text(
        shipping === 0 ? "Free" : "$" + shipping.toFixed(2)
      );

      const total = totalPrice + shipping;
      $(".total-value").text("$" + total.toFixed(2));

      $(".cart-summary").show();
    }

    // Update item quantity
    function updateItemQuantity(id, action) {
      const itemIndex = cart.findIndex((item) => item.id === id);

      if (itemIndex !== -1) {
        if (action === "decrease" && cart[itemIndex].quantity > 1) {
          cart[itemIndex].quantity -= 1;
        } else if (action === "increase") {
          cart[itemIndex].quantity += 1;
        }

        localStorage.setItem("cart", JSON.stringify(cart));
        displayCartItems();
        updateCartCount();
      }
    }

    // Remove item from cart
    function removeItemFromCart(id) {
      cart = cart.filter((item) => item.id !== id);

      localStorage.setItem("cart", JSON.stringify(cart));
      displayCartItems();
      updateCartCount();
      showNotification("Item removed from cart");
    }

    // Coupon code handling
    $(".btn-outline-secondary").on("click", function () {
      // Updated selector
      const couponCode = $("input[placeholder='Coupon Code']")
        .val()
        .trim()
        .toUpperCase();

      if (!couponCode) {
        showNotification("Please enter a coupon code", "warning");
        return;
      }

      // Simulate coupon validation
      $(this)
        .html(
          '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>'
        )
        .prop("disabled", true);

      setTimeout(() => {
        if (couponCode === "SAVE10") {
          showNotification(
            "Coupon applied successfully! 10% discount added.",
            "success"
          );

          // Apply discount to cart
          let subtotal = parseFloat(
            $(".subtotal-value").text().replace("$", "")
          );
          const discount = subtotal * 0.1;
          subtotal -= discount;

          // Update display
          $(".subtotal-value").text("$" + subtotal.toFixed(2));

          // Add discount row
          if ($(".discount-row").length === 0) {
            $(".subtotal-value").closest(".d-flex").after(`
              <div class="d-flex justify-content-between mb-3 discount-row">
                <span class="text-success">Discount (10%)</span>
                <span class="text-success">-$${discount.toFixed(2)}</span>
              </div>
            `);
          }

          // Update total
          const shipping = subtotal >= 100 ? 0 : 10;
          $(".shipping-value").text(
            shipping === 0 ? "Free" : "$" + shipping.toFixed(2)
          );

          const total = subtotal + shipping;
          $(".total-value").text("$" + total.toFixed(2));

          // Store coupon in session
          sessionStorage.setItem("appliedCoupon", couponCode);
          sessionStorage.setItem("discountAmount", discount.toString());
        } else {
          showNotification("Invalid coupon code", "error");
        }

        $(this).html("Apply").prop("disabled", false);
      }, 800);
    });
  }

  // Checkout page functionality
  if ($(".checkout-page").length) {
    updateCheckoutSummary();

    // Form validation
    $("#checkout-form").on("submit", function (e) {
      e.preventDefault();

      if (this.checkValidity()) {
        // Process order (in a real app, this would send data to a server)
        $("#processing-order-modal").modal("show");

        setTimeout(() => {
          $("#processing-order-modal").modal("hide");
          showOrderConfirmation();
        }, 2000);
      }

      $(this).addClass("was-validated");
    });

    // Shipping method selection
    $("input[name='shippingMethod']").on("change", function () {
      updateCheckoutSummary();
    });

    // Update order summary
    function updateCheckoutSummary() {
      const summaryContainer = $(".order-summary");
      summaryContainer.empty();

      let subtotal = 0;

      cart.forEach((item) => {
        const itemTotal = item.price * item.quantity;
        subtotal += itemTotal;

        summaryContainer.append(`
          <div class="d-flex justify-content-between mb-2">
            <span>${item.name} × ${item.quantity}</span>
            <span>$${itemTotal.toFixed(2)}</span>
          </div>
        `);
      });

      // Get shipping cost based on selected method
      let shippingMethod = $("input[name='shippingMethod']:checked").val();
      let shipping;

      if (subtotal >= 100 && shippingMethod === "standard") {
        shipping = 0;
      } else {
        switch (shippingMethod) {
          case "express":
            shipping = 20;
            break;
          case "nextday":
            shipping = 30;
            break;
          default:
            shipping = 10; // standard
        }
      }

      const total = subtotal + shipping;

      // Apply tax
      const tax = total * 0.08; // 8% tax rate
      const grandTotal = total + tax;

      summaryContainer.append(`
        <hr>
        <div class="d-flex justify-content-between mb-2">
          <span>Subtotal</span>
          <span>$${subtotal.toFixed(2)}</span>
        </div>
        <div class="d-flex justify-content-between mb-2">
          <span>Shipping</span>
          <span>${shipping === 0 ? "Free" : "$" + shipping.toFixed(2)}</span>
        </div>
        <div class="d-flex justify-content-between mb-2">
          <span>Tax (8%)</span>
          <span>$${tax.toFixed(2)}</span>
        </div>
        <div class="d-flex justify-content-between fw-bold">
          <span>Total</span>
          <span>$${grandTotal.toFixed(2)}</span>
        </div>
      `);
    }

    // Show order confirmation
    function showOrderConfirmation() {
      // In a real app, you'd get an order number from your backend
      const orderNumber = "ORD" + Math.floor(100000 + Math.random() * 900000);

      // Clear cart
      cart = [];
      localStorage.setItem("cart", JSON.stringify(cart));
      updateCartCount();

      // Redirect to thank you page with order information
      window.location.href = `order-confirmation.html?order=${orderNumber}`;
    }

    // Address autofill feature
    $("#shipping-same-billing").on("change", function () {
      if ($(this).is(":checked")) {
        // Copy billing address to shipping address
        $("#shipping-firstname").val($("#billing-firstname").val());
        $("#shipping-lastname").val($("#billing-lastname").val());
        $("#shipping-address").val($("#billing-address").val());
        $("#shipping-city").val($("#billing-city").val());
        $("#shipping-state").val($("#billing-state").val());
        $("#shipping-zip").val($("#billing-zip").val());

        // Disable shipping address fields
        $(
          "#shipping-address-container input, #shipping-address-container select"
        ).prop("disabled", true);
      } else {
        // Enable shipping address fields
        $(
          "#shipping-address-container input, #shipping-address-container select"
        ).prop("disabled", false);
      }
    });

    // Payment method selection
    $("input[name='paymentMethod']").on("change", function () {
      const method = $(this).val();

      // Hide all payment details divs
      $(".payment-details").hide();

      // Show the selected payment method details
      $("#" + method + "-details").show();
    });
  }

  // Product listing page functionality
  if ($(".products-page").length) {
    // Price range slider
    $("#priceRange").on("input", function () {
      const value = $(this).val();
      $("#priceValue").text("$" + value);
      // Optional: Trigger filtering immediately on slider change
      // filterProducts();
    });

    // Filter checkboxes
    $(".filter-checkbox").on("change", function () {
      // Optional: Trigger filtering immediately on checkbox change
      // filterProducts();
    });

    // Apply Filters button
    $(".apply-filters-btn").on("click", function () {
      // Changed selector
      filterProducts();
    });

    // Sort dropdown
    $("#sort").on("change", function () {
      sortProducts($(this).val());
    });

    // Quick view buttons (Placeholder - needs modal content logic)
    $(document).on("click", ".quick-view-btn", function (e) {
      e.preventDefault();
      const productId = $(this).data("id");
      showQuickViewModal(productId);
    });

    // Product comparison functionality
    let compareProducts =
      JSON.parse(sessionStorage.getItem("compareProducts")) || [];
    updateCompareCheckboxes(); // Set initial state of checkboxes
    updateCompareBar(); // Show bar if items were already in session

    $(document).on("change", ".compare-checkbox", function () {
      const productId = $(this).data("id");
      const productName = $(this).data("name");

      if ($(this).is(":checked")) {
        addToCompare(productId, productName);
      } else {
        removeFromCompare(productId);
      }
    });

    // Add to Wishlist from Grid
    $(document).on("click", ".add-to-wishlist-grid", function () {
      const button = $(this);
      const productId = parseInt(button.data("id"));
      const icon = button.find("i");

      // Basic toggle without full wishlist logic for now
      if (icon.hasClass("far")) {
        icon.removeClass("far").addClass("fas"); // Change to solid heart
        button.addClass("active"); // Optional: Add active class
        showNotification("Added to wishlist (Demo)", "success");
        // Add to actual wishlist array/storage here
      } else {
        icon.removeClass("fas").addClass("far"); // Change back to regular heart
        button.removeClass("active");
        showNotification("Removed from wishlist (Demo)", "warning");
        // Remove from actual wishlist array/storage here
      }
    });

    function filterProducts() {
      // Gather selected filters
      const categories = [];
      $('input[id^="cat"]:checked').each(function () {
        categories.push($(this).val());
      });

      const brands = [];
      $('input[id^="brand"]:checked').each(function () {
        brands.push($(this).val());
      });

      const shapes = [];
      $('input[id^="shape"]:checked').each(function () {
        shapes.push($(this).val());
      });

      const materials = [];
      $('input[id^="material"]:checked').each(function () {
        materials.push($(this).val());
      });

      const maxPrice = $("#priceRange").val();

      console.log("Filtering by:", {
        categories,
        brands,
        shapes,
        materials,
        maxPrice,
      }); // Log selected filters

      // Add visual indicator
      $(".product-grid").addClass("filtering");

      setTimeout(() => {
        $(".product-grid").removeClass("filtering");
        showNotification("Products filtered (Demo)", "info");
        // In a real app, update the product grid HTML here based on filter criteria
        // This would involve fetching data or manipulating the DOM
      }, 800);
    }

    function sortProducts(sortMethod) {
      console.log("Sorting by:", sortMethod); // Log selected sort method

      // Add visual indicator
      $(".product-grid").addClass("sorting");

      setTimeout(() => {
        $(".product-grid").removeClass("sorting");
        showNotification(
          `Products sorted by ${sortMethod.replace("-", " ")} (Demo)`, // Improved message
          "info"
        );
        // In a real app, reorder and update the product grid HTML here based on sortMethod
      }, 800);
    }

    function showQuickViewModal(productId) {
      // In a real implementation, this would populate the modal with product details via AJAX
      const quickViewModal = new bootstrap.Modal(
        document.getElementById("quickViewModal")
      );
      // Example: Fetch data and update modal body
      // $("#quickViewModal .modal-body").html(`<p>Loading details for product ${productId}...</p>`);
      quickViewModal.show();
    }

    function addToCompare(id, name) {
      if (compareProducts.length >= 3) {
        showNotification("You can compare up to 3 products.", "warning");
        // Uncheck the box
        $(`.compare-checkbox[data-id="${id}"]`).prop("checked", false);
        return;
      }
      if (!compareProducts.some((p) => p.id === id)) {
        compareProducts.push({ id, name });
        sessionStorage.setItem(
          "compareProducts",
          JSON.stringify(compareProducts)
        );
        updateCompareBar();
      }
    }

    function removeFromCompare(id) {
      compareProducts = compareProducts.filter((p) => p.id !== id);
      sessionStorage.setItem(
        "compareProducts",
        JSON.stringify(compareProducts)
      );
      updateCompareBar();
    }

    function updateCompareBar() {
      const compareBar = $("#compare-bar");

      if (compareProducts.length > 0) {
        if (compareBar.length === 0) {
          $("body").append(`
            <div id="compare-bar" class="fixed-bottom bg-dark text-white p-3 shadow-lg">
              <div class="container">
                <div class="row align-items-center">
                  <div class="col-md-3">
                    <h5 class="mb-0">Compare Products (${compareProducts.length}/3)</h5>
                  </div>
                  <div class="col-md-6 text-center" id="compare-items">
                    <!-- Items added here -->
                  </div>
                  <div class="col-md-3 text-end">
                    <button id="compare-now-btn" class="btn btn-primary btn-sm me-2">Compare Now</button>
                    <button id="clear-compare-btn" class="btn btn-outline-light btn-sm">Clear All</button>
                  </div>
                </div>
              </div>
            </div>
          `);

          // Add event handlers only once
          $("#compare-now-btn").on("click", function () {
            // Redirect to compare page or show compare modal
            showNotification("Compare page/modal not implemented yet.", "info");
          });

          $("#clear-compare-btn").on("click", function () {
            compareProducts = [];
            sessionStorage.removeItem("compareProducts");
            $(".compare-checkbox").prop("checked", false);
            $("#compare-bar").remove();
          });
        }

        // Update items list
        const itemsHtml = compareProducts
          .map(
            (p) =>
              `<span class="badge bg-light text-dark me-2 compare-item-badge" data-id="${p.id}">${p.name} <a href="#" class="remove-compare text-danger ms-1" data-id="${p.id}" title="Remove">×</a></span>`
          )
          .join("");
        $("#compare-items").html(itemsHtml);

        // Re-attach event handlers for remove buttons within the bar
        $(".remove-compare")
          .off("click")
          .on("click", function (e) {
            // Use .off().on() to prevent duplicates
            e.preventDefault();
            const id = $(this).data("id");
            $(`.compare-checkbox[data-id="${id}"]`)
              .prop("checked", false)
              .trigger("change");
          });
      } else {
        compareBar.remove();
      }
    }

    function updateCompareCheckboxes() {
      $(".compare-checkbox").each(function () {
        const id = $(this).data("id");
        if (compareProducts.some((p) => p.id === id)) {
          $(this).prop("checked", true);
        } else {
          $(this).prop("checked", false);
        }
      });
    }
  }

  // Order Confirmation Page
  if ($(".order-confirmation-page").length) {
    const urlParams = new URLSearchParams(window.location.search);
    const orderNumber = urlParams.get("order");

    if (orderNumber) {
      $("#order-number").text(orderNumber);
    } else {
      $("#order-number").text("N/A");
    }
    // Ensure cart count is updated (should be 0 after checkout)
    updateCartCount();
  }

  // Wishlist Page Functionality
  if ($(".wishlist-page").length) {
    displayWishlistItems();

    // Remove from wishlist
    $(document).on("click", ".remove-from-wishlist", function () {
      const id = parseInt($(this).closest(".wishlist-item").data("id")); // Ensure ID is integer
      const row = $(this).closest(".wishlist-item");

      // Animate removal
      row.addClass("removing");
      setTimeout(() => {
        wishlist = wishlist.filter((item) => item.id !== id);
        localStorage.setItem("wishlist", JSON.stringify(wishlist));
        displayWishlistItems(); // Re-render wishlist
        showNotification("Item removed from wishlist");
      }, 300);
    });

    // Add to cart from wishlist (Simplified: uses default options)
    $(document).on("click", ".add-to-cart-from-wishlist", function () {
      const id = parseInt($(this).closest(".wishlist-item").data("id")); // Ensure ID is integer
      const wishlistItem = wishlist.find((item) => item.id === id);

      if (wishlistItem) {
        // Check if already in cart (basic check, no options considered here)
        const existingCartItem = cart.find((item) => item.id === id);
        if (existingCartItem) {
          existingCartItem.quantity += 1;
        } else {
          cart.push({
            id: wishlistItem.id,
            name: wishlistItem.name,
            price: wishlistItem.price,
            quantity: 1,
            image: wishlistItem.image,
            // Add default color/size/lens if needed, or redirect to product page
            color: "Default",
            size: "Default",
            lensType: "Standard",
          });
        }
        localStorage.setItem("cart", JSON.stringify(cart));
        updateCartCount();
        showNotification(`${wishlistItem.name} added to cart!`);

        // Optionally remove from wishlist after adding to cart
        // wishlist = wishlist.filter((item) => item.id !== id);
        // localStorage.setItem("wishlist", JSON.stringify(wishlist));
        // displayWishlistItems();
      }
    });
  }

  function displayWishlistItems() {
    const wishlistContainer = $(".wishlist-items");
    wishlistContainer.empty();
    wishlist = JSON.parse(localStorage.getItem("wishlist")) || []; // Ensure wishlist is up-to-date

    if (wishlist.length === 0) {
      wishlistContainer.append(
        `<div class="text-center py-5">
                  <div class="empty-cart-icon mb-3">
                      <i class="far fa-heart fa-4x text-muted"></i>
                  </div>
                  <h4>Your wishlist is empty</h4>
                  <p class="text-muted">Save your favorite items here to view them later.</p>
                  <a href="products.html" class="btn btn-primary mt-3">Discover Products</a>
              </div>`
      );
      return;
    }

    wishlist.forEach((item) => {
      wishlistContainer.append(`
              <div class="card product-card wishlist-item mb-3" data-id="${
                item.id
              }">
                  <div class="row g-0">
                      <div class="col-md-2 d-flex align-items-center justify-content-center p-2">
                          <img src="${
                            item.image ||
                            "https://via.placeholder.com/150x100?text=Product"
                          }" class="img-fluid rounded" alt="${
        item.name
      }" style="max-height: 100px; width: auto;">
                      </div>
                      <div class="col-md-7">
                          <div class="card-body">
                              <h5 class="card-title">${item.name}</h5>
                              <p class="card-text fw-bold">$${
                                item.price ? item.price.toFixed(2) : "N/A"
                              }</p>
                              <button class="btn btn-primary btn-sm add-to-cart-from-wishlist">Add to Cart</button>
                              <a href="product-detail.html?id=${
                                item.id
                              }" class="btn btn-outline-secondary btn-sm ms-2">View Product</a>
                          </div>
                      </div>
                      <div class="col-md-3 d-flex align-items-center justify-content-center">
                          <button class="btn btn-sm btn-link text-danger remove-from-wishlist" title="Remove from Wishlist"><i class="fas fa-trash fa-lg"></i></button>
                      </div>
                  </div>
              </div>
          `);
    });
  }

  // Account page functionality
  if ($("body").hasClass("account-page")) {
    // Use class selector
    // Check if user is logged in
    if (!isLoggedIn || !currentUser) {
      window.location.href = "login.html";
      return; // Stop execution if not logged in
    }

    // Load and display orders
    displayUserOrders();

    // Display user information
    displayUserInformation();

    // Load addresses
    displayUserAddresses();

    // Handle tab change based on URL hash
    const hash = window.location.hash;
    if (hash) {
      const triggerEl = document.querySelector(
        `.account-nav a[href="${hash}"]`
      );
      if (triggerEl) {
        const tab = new bootstrap.Tab(triggerEl);
        tab.show();
      }
    }

    // Update addresses form submission
    $("#updateAddresses").on("submit", function (e) {
      e.preventDefault();

      // Get address data
      const shippingAddress = {
        firstName: $("#shipping-first-name").val(),
        lastName: $("#shipping-last-name").val(),
        address1: $("#shipping-address1").val(),
        address2: $("#shipping-address2").val(),
        city: $("#shipping-city").val(),
        state: $("#shipping-state").val(),
        zip: $("#shipping-zip").val(),
        country: $("#shipping-country").val(),
      };

      const billingAddress = {
        firstName: $("#billing-first-name").val(),
        lastName: $("#billing-last-name").val(),
        address1: $("#billing-address1").val(),
        address2: $("#billing-address2").val(),
        city: $("#billing-city").val(),
        state: $("#billing-state").val(),
        zip: $("#billing-zip").val(),
        country: $("#billing-country").val(),
      };

      // Save addresses to user data in localStorage
      const users = JSON.parse(localStorage.getItem("users")) || [];
      const userIndex = users.findIndex((u) => u.email === currentUser.email);

      if (userIndex !== -1) {
        if (!users[userIndex].addresses) {
          users[userIndex].addresses = {};
        }
        users[userIndex].addresses.shipping = shippingAddress;
        users[userIndex].addresses.billing = billingAddress;
        localStorage.setItem("users", JSON.stringify(users));
        showNotification("Addresses updated successfully", "success");
      } else {
        showNotification("Error updating addresses. User not found.", "error");
      }
    });

    // Same as Billing checkbox functionality
    $("#sameAsBilling").on("change", function () {
      const isChecked = $(this).is(":checked");
      const shippingFields = $(
        "#addresses .col-md-6:last-child input, #addresses .col-md-6:last-child select"
      ); // Target shipping fields

      if (isChecked) {
        $("#shipping-first-name").val($("#billing-first-name").val());
        $("#shipping-last-name").val($("#billing-last-name").val());
        $("#shipping-address1").val($("#billing-address1").val());
        $("#shipping-address2").val($("#billing-address2").val());
        $("#shipping-city").val($("#billing-city").val());
        $("#shipping-state").val($("#billing-state").val());
        $("#shipping-zip").val($("#billing-zip").val());
        $("#shipping-country").val($("#billing-country").val());
        shippingFields.prop("disabled", true);
      } else {
        shippingFields.prop("disabled", false);
        // Optionally clear shipping fields
        // shippingFields.val('');
      }
    });

    // Update profile form submission
    $("#updateProfile").on("submit", function (e) {
      e.preventDefault();

      const name = $("#profile-name").val();
      const phone = $("#profile-phone").val();
      const currentPassword = $("#current-password").val();
      const newPassword = $("#new-password").val();
      const confirmNewPassword = $("#confirm-new-password").val();

      // Get current user data
      const users = JSON.parse(localStorage.getItem("users")) || [];
      const userIndex = users.findIndex((u) => u.email === currentUser.email);

      if (userIndex === -1) {
        showNotification("Error updating profile. User not found.", "error");
        return;
      }

      let user = users[userIndex];
      let changesMade = false;

      // Update name and phone
      if (user.name !== name || (user.phone || "") !== phone) {
        user.name = name;
        user.phone = phone;
        changesMade = true;
      }

      // Update password if fields are filled
      if (newPassword) {
        if (!currentPassword) {
          showNotification(
            "Please enter your current password to change it.",
            "warning"
          );
          return;
        }
        if (user.password !== currentPassword) {
          // In real app, compare hashed passwords
          showNotification("Incorrect current password.", "error");
          return;
        }
        if (newPassword.length < 8) {
          showNotification(
            "New password must be at least 8 characters long.",
            "warning"
          );
          return;
        }
        if (newPassword !== confirmNewPassword) {
          showNotification("New passwords do not match.", "warning");
          return;
        }
        user.password = newPassword; // In real app, hash the new password
        changesMade = true;
      }

      if (changesMade) {
        users[userIndex] = user;
        localStorage.setItem("users", JSON.stringify(users));

        // Update currentUser in localStorage and the global variable
        currentUser.name = user.name; // Update name in current session
        localStorage.setItem("currentUser", JSON.stringify(currentUser));

        showNotification("Profile updated successfully", "success");

        // Clear password fields
        $("#current-password, #new-password, #confirm-new-password").val("");
      } else {
        showNotification("No changes detected.", "info");
      }
    });
  }

  // Function to display user orders on account page
  function displayUserOrders() {
    const orderListContainer = $("#orders .order-list");
    orderListContainer.empty(); // Clear previous content

    const allOrders = JSON.parse(localStorage.getItem("orders")) || [];
    // Filter orders for the current user (assuming orders store user email or ID)
    // For this example, we'll assume orders don't have user association yet, so show all.
    // In a real app: const userOrders = allOrders.filter(order => order.customer.email === currentUser.email);
    const userOrders = allOrders; // DEMO: Show all orders

    if (userOrders.length === 0) {
      orderListContainer.html("<p>You have not placed any orders yet.</p>");
      return;
    }

    const accordion = $('<div class="accordion" id="ordersAccordion"></div>');

    userOrders.reverse().forEach((order, index) => {
      // Show newest first
      const orderDate = new Date(order.date).toLocaleDateString();
      const statusBadge = getOrderStatusBadge(order.status);

      accordion.append(`
        <div class="accordion-item">
          <h2 class="accordion-header" id="heading${order.id}">
            <button class="accordion-button ${
              index > 0 ? "collapsed" : ""
            }" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${
        order.id
      }" aria-expanded="${
        index === 0 ? "true" : "false"
      }" aria-controls="collapse${order.id}">
              Order #${order.id} - ${orderDate} - Total: $${order.total.toFixed(
        2
      )} ${statusBadge}
            </button>
          </h2>
          <div id="collapse${order.id}" class="accordion-collapse collapse ${
        index === 0 ? "show" : ""
      }" aria-labelledby="heading${order.id}" data-bs-parent="#ordersAccordion">
            <div class="accordion-body">
              <h6>Order Details</h6>
              <p><strong>Date:</strong> ${orderDate}<br>
                 <strong>Status:</strong> ${order.status}<br>
                 <strong>Shipping To:</strong> ${order.shipping.address}, ${
        order.shipping.city
      }, ${order.shipping.state} ${order.shipping.zip}</p>
              <h6>Items</h6>
              <ul class="list-group list-group-flush">
                ${order.items
                  .map(
                    (item) => `
                  <li class="list-group-item d-flex justify-content-between align-items-center">
                    ${item.name} (×${item.quantity})
                    <span>$${item.total.toFixed(2)}</span>
                  </li>
                `
                  )
                  .join("")}
              </ul>
              <div class="text-end mt-2">
                <p class="mb-1">Subtotal: $${order.subtotal.toFixed(2)}</p>
                <p class="mb-1">Shipping: $${order.shipping.toFixed(2)}</p>
                <p class="mb-1">Tax: $${order.tax.toFixed(2)}</p>
                <p class="fw-bold mb-0">Total: $${order.total.toFixed(2)}</p>
              </div>
              <div class="mt-3">
                 <button class="btn btn-sm btn-outline-secondary track-order-btn" data-order-id="${
                   order.id
                 }">Track Order</button>
                 <button class="btn btn-sm btn-outline-danger cancel-order-btn" data-order-id="${
                   order.id
                 }" ${
        order.status !== "Processing" ? "disabled" : ""
      }>Cancel Order</button>
              </div>
            </div>
          </div>
        </div>
      `);
    });

    orderListContainer.append(accordion);
  }

  // Helper function for order status badge
  function getOrderStatusBadge(status) {
    let badgeClass = "bg-secondary";
    switch (status.toLowerCase()) {
      case "processing":
        badgeClass = "bg-warning text-dark";
        break;
      case "shipped":
        badgeClass = "bg-info text-dark";
        break;
      case "delivered":
        badgeClass = "bg-success";
        break;
      case "cancelled":
        badgeClass = "bg-danger";
        break;
    }
    return `<span class="badge ${badgeClass} ms-2">${status}</span>`;
  }

  // Function to display user information on account page
  function displayUserInformation() {
    if (currentUser) {
      $("#user-welcome-name").text(currentUser.name); // Update dashboard welcome
      $("#profile-name").val(currentUser.name);
      $("#profile-email").val(currentUser.email);

      // Load phone from full user data if available
      const users = JSON.parse(localStorage.getItem("users")) || [];
      const fullUser = users.find((u) => u.email === currentUser.email);
      if (fullUser && fullUser.phone) {
        $("#profile-phone").val(fullUser.phone);
      }
    }
  }

  // Function to display user addresses on account page
  function displayUserAddresses() {
    const users = JSON.parse(localStorage.getItem("users")) || [];
    const user = users.find((u) => u.email === currentUser.email);

    if (user && user.addresses) {
      const { billing, shipping } = user.addresses;

      if (billing) {
        $("#billing-first-name").val(billing.firstName || "");
        $("#billing-last-name").val(billing.lastName || "");
        $("#billing-address1").val(billing.address1 || "");
        $("#billing-address2").val(billing.address2 || "");
        $("#billing-city").val(billing.city || "");
        $("#billing-state").val(billing.state || "");
        $("#billing-zip").val(billing.zip || "");
        $("#billing-country").val(billing.country || "");
      }

      if (shipping) {
        $("#shipping-first-name").val(shipping.firstName || "");
        $("#shipping-last-name").val(shipping.lastName || "");
        $("#shipping-address1").val(shipping.address1 || "");
        $("#shipping-address2").val(shipping.address2 || "");
        $("#shipping-city").val(shipping.city || "");
        $("#shipping-state").val(shipping.state || "");
        $("#shipping-zip").val(shipping.zip || "");
        $("#shipping-country").val(shipping.country || "");
      }
    }
  }
}); // End of $(document).ready()
