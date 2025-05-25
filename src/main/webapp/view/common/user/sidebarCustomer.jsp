<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="col-lg-3">
    <!-- Dropdown Search Box -->
    <div class="dashboard__sidebar-title mt-30 mb-20">
        <h6 class="title"></h6>
    </div>
    <div style="margin-bottom:50px;">
        <div style="display: flex; align-items: center; border: 1px solid #ccc; border-radius: 3px; overflow: hidden;">
            <select style="border: none; padding: 10px; height: 100%; outline: none;">
                <option>Categories</option>
                <option>Business</option>
                <option>Data Science</option>
                <option>Art & Design</option>
                <option>Marketing</option>
                <option>Finance</option>
            </select>
            <input type="text" placeholder="Search For Course . . ." style="flex: 1; border: none; padding: 10px; outline: none;" />
            <button style="background-color: #6c63ff; border: none; padding: 10px; cursor: pointer;">
                <img src="search-icon.png" alt="Search" style="width: 20px; height: 20px;" />
            </button>
        </div>
    </div>

    <div class="dashboard__sidebar-wrap">
        <div class="dashboard__sidebar-title mb-20">
            <h6 class="title">Welcome, Jone Due</h6>
        </div>
        <nav class="dashboard__sidebar-menu">
            <ul class="list-wrap">
                <li>
                    <a href="instructor-profile.html">
                        <i class="skillgro-avatar"></i>
                        My Profile
                    </a>
                </li>
                <li>
                    <a href="instructor-attempts.html">
                        <i class="skillgro-question"></i>
                        My Quiz Attempts
                    </a>
                </li>
                <li class = "active">
                    <a href="instructor-history.html">
                        <i class="skillgro-satchel"></i>
                        My Registration
                    </a>
                </li>
            </ul>
        </nav>

        <div class="dashboard__sidebar-title mt-30 mb-20">
            <h6 class="title">User</h6>
        </div>
        <nav class="dashboard__sidebar-menu">
            <ul class="list-wrap">
                <li>
                    <a href="index.html">
                        <i class="skillgro-logout"></i>
                        Logout
                    </a>
                </li>
            </ul>
        </nav>
    </div>
</div>
