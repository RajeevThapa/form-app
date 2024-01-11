<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve form data
    $name = $_POST["name"];
    $email = $_POST["email"];

    // Process the data (you can perform database operations or other actions here)
    
    // Display a simple response
    echo "<h2>Thank you for submitting the form, $name!</h2>";
} else {
    // Redirect to the form if accessed directly without submitting
    header("Location: index.html");
    exit();
}
?>
