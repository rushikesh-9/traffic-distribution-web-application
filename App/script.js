    <script>
        // Populate the confirmation page with data from localStorage
        document.addEventListener("DOMContentLoaded", function () {
            document.getElementById("confirmName").textContent = localStorage.getItem("name");
            document.getElementById("confirmMobile").textContent = localStorage.getItem("mobile");
            document.getElementById("confirmEmail").textContent = localStorage.getItem("email");
            document.getElementById("confirmPassengers").textContent = localStorage.getItem("passengers");
            document.getElementById("confirmFrom").textContent = localStorage.getItem("from");
            document.getElementById("confirmDestination").textContent = localStorage.getItem("destination");
            document.getElementById("confirmDate").textContent = localStorage.getItem("date");

            // Clear the localStorage after confirming
            localStorage.clear();
        });
    </script>

