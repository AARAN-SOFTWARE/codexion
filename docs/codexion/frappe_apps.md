
npm install frappe-ui

bench get-app crm --branch develop
bench --site site1.com install-app crm

bench get-app hrms --branch develop
bench --site site1.com install-app hrms

bench get-app builder --branch develop
bench --site site1.com install-app builder 

bench get-app https://github.com/resilient-tech/india-compliance.git --branch develop
bench --site site1.com install-app india_compliance


bench pip install setuptools

bench get-app lms --branch develop
bench --site site1.com install-app lms

bench get-app gameplan --branch develop
bench --site site1.com install-app gameplan


bench get-app wiki --branch master
bench --site site1.com install-app wiki

bench get-app helpdesk --branch develop
bench --site site1.com install-app helpdesk

bench get-app insights --branch develop
bench --site site1.com install-app insights


sudo apt install ffmpeg libmagic
bench get-app drive --branch main
bench install-app drive


bench get-app press --branch master
bench --site site1.com install-app press


bench --site site1.com migrate
bench --site site1.com clear-cache
bench --site site1.com reload-doc lms lms doctype course_evaluator

bench --site site1.com reinstall
bench --site site1.com install-app lms

npx update-browserslist-db@latest