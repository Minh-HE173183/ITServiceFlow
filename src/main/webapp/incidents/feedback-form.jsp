<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- CSAT Survey Form -->
<div class="card shadow-sm border-0 mt-4 border-top border-4 border-success">
    <div class="card-header bg-white py-3">
        <h5 class="mb-0 text-dark fw-bold"><i class="bi bi-star-fill me-2 text-warning"></i>Customer Satisfaction Survey</h5>
    </div>
    <div class="card-body p-4">
        <div class="alert alert-success mb-4">
            <i class="bi bi-check-circle me-2"></i>
            <strong>Thank you for your patience!</strong> This ticket has been successfully resolved. 
            Please take a moment to rate our service and provide feedback.
        </div>
        
        <form action="${pageContext.request.contextPath}/feedback" method="post">
            <input type="hidden" name="action" value="submit">
            <input type="hidden" name="ticketId" value="${incident.ticketId}">
            
            <!-- Rating Section -->
            <div class="mb-4">
                <label class="form-label fw-bold fs-5">Overall Satisfaction</label>
                <div class="rating-group">
                    <div class="btn-group" role="group" aria-label="Rating">
                        <input type="radio" class="btn-check" name="rating" id="rating1" value="1" required>
                        <label class="btn btn-outline-warning btn-lg" for="rating1">
                            <i class="bi bi-star"></i>
                        </label>
                        
                        <input type="radio" class="btn-check" name="rating" id="rating2" value="2">
                        <label class="btn btn-outline-warning btn-lg" for="rating2">
                            <i class="bi bi-star"></i><i class="bi bi-star"></i>
                        </label>
                        
                        <input type="radio" class="btn-check" name="rating" id="rating3" value="3">
                        <label class="btn btn-outline-warning btn-lg" for="rating3">
                            <i class="bi bi-star"></i><i class="bi bi-star"></i><i class="bi bi-star"></i>
                        </label>
                        
                        <input type="radio" class="btn-check" name="rating" id="rating4" value="4">
                        <label class="btn btn-outline-warning btn-lg" for="rating4">
                            <i class="bi bi-star"></i><i class="bi bi-star"></i><i class="bi bi-star"></i><i class="bi bi-star"></i>
                        </label>
                        
                        <input type="radio" class="btn-check" name="rating" id="rating5" value="5">
                        <label class="btn btn-outline-warning btn-lg" for="rating5">
                            <i class="bi bi-star"></i><i class="bi bi-star"></i><i class="bi bi-star"></i><i class="bi bi-star"></i><i class="bi bi-star"></i>
                        </label>
                    </div>
                    <div class="form-text mt-2">
                        <span class="badge bg-light text-dark">1 Star</span>
                        <span class="badge bg-light text-dark ms-2">2 Stars</span>
                        <span class="badge bg-light text-dark ms-2">3 Stars</span>
                        <span class="badge bg-light text-dark ms-2">4 Stars</span>
                        <span class="badge bg-light text-dark ms-2">5 Stars</span>
                    </div>
                </div>
            </div>
            
            <!-- Feedback Text Section -->
            <div class="mb-4">
                <label for="feedbackText" class="form-label fw-bold fs-5">Additional Feedback</label>
                <textarea class="form-control border-secondary" id="feedbackText" name="feedbackText" 
                         rows="4" placeholder="Please share your thoughts about our service..."></textarea>
                <div class="form-text">Your feedback helps us improve our service quality.</div>
            </div>
            
            <!-- Submit Button -->
            <div class="d-flex gap-3">
                <button type="submit" class="btn btn-success btn-lg px-4">
                    <i class="bi bi-check-circle me-2"></i>Submit Feedback
                </button>
                <button type="button" class="btn btn-outline-secondary btn-lg px-4" onclick="hideSurvey()">
                    <i class="bi bi-x-circle me-2"></i>Not Now
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function hideSurvey() {
        document.getElementById('surveySection').style.display = 'none';
    }
</script>