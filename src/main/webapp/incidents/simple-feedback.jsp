<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Simple Feedback Section -->
<div class="card shadow-sm border-0 mt-4 border-top border-4 border-success">
    <div class="card-header bg-white py-3">
        <h5 class="mb-0 text-dark fw-bold">📊 Đánh Giá Dịch Vụ</h5>
    </div>
    <div class="card-body p-4 text-center">
        <div class="alert alert-success mb-4">
            <strong>Cảm ơn bạn đã sử dụng dịch vụ!</strong> 
            Vui lòng đánh giá mức độ hài lòng của bạn.
        </div>
        
        <div class="feedback-container">
            <p class="fs-5 mb-4">Bạn có hài lòng với dịch vụ?</p>
            
            <div class="btn-group" role="group" aria-label="Simple feedback">
                <button type="button" class="btn btn-success btn-lg px-4 py-3 me-3" 
                        onclick="submitFeedback(1)" style="font-size: 1.2rem;">
                    <i class="bi bi-hand-thumbs-up me-2"></i>👍 Hài lòng
                </button>
                <button type="button" class="btn btn-danger btn-lg px-4 py-3" 
                        onclick="submitFeedback(0)" style="font-size: 1.2rem;">
                    <i class="bi bi-hand-thumbs-down me-2"></i>👎 Chưa hài lòng
                </button>
            </div>
            
            <div id="feedbackMessage" class="mt-4 text-muted" style="display: none;">
                Cảm ơn bạn đã đánh giá!
            </div>
        </div>
    </div>
</div>

<script>
function submitFeedback(rating) {
    // Ẩn các nút feedback
    document.querySelector('.feedback-container').style.display = 'none';
    
    // Hiển thị thông báo cảm ơn
    document.getElementById('feedbackMessage').style.display = 'block';
    
    // Gửi feedback bằng fetch API
    fetch('${pageContext.request.contextPath}/feedback', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=submit&ticketId=${incident.ticketId}&rating=' + rating
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.text();
    })
    .then(data => {
        console.log('Feedback submitted successfully');
    })
    .catch(error => {
        console.error('Error submitting feedback:', error);
        // Nếu có lỗi, hiển thị lại các nút
        document.querySelector('.feedback-container').style.display = 'block';
        document.getElementById('feedbackMessage').style.display = 'none';
    });
}
</script>