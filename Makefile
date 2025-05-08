# Define the path to the script and the cron job
.PHONY: setup-env add-cron list-cron remove-cron

PATH_SCRIPT := ~/Workspace/cloudflare-update-dns/cloudflare-update-dns.sh
CRON_JOB := */5 * * * * $(PATH_SCRIPT)

# Define Cloudflare environment variables
CLOUDFLARE_ZONE_ID := your_zone_id
CLOUDFLARE_RECORD_ID := your_record_id
CLOUDFLARE_DOMAIN_NAME := your_domain_name
CLOUDFLARE_CUR_IPV6 := your_current_ipv6
CLOUDFLARE_EMAIL := your_email
CLOUDFLARE_AUTH_KEY := your_auth_key

# Add the cron job
add-cron:
	@echo "$(CRON_JOB)" | crontab -
	@echo "✅ Cron job added."

# List current cron jobs
list-cron:
	@crontab -l

# Remove the cron job (if needed)
remove-cron:
	@crontab -l | grep -v "$(PATH_SCRIPT)" | crontab -
	@echo "🗑️ Cron job removed."

# Setup environment variables in .bashrc
setup-env:
	@echo "Setting environment variables in ~/.bashrc..."
	@echo "export CLOUDFLARE_ZONE_ID=$(CLOUDFLARE_ZONE_ID)" >> ~/.bashrc
	@echo "export CLOUDFLARE_RECORD_ID=$(CLOUDFLARE_RECORD_ID)" >> ~/.bashrc
	@echo "export CLOUDFLARE_DOMAIN_NAME=$(CLOUDFLARE_DOMAIN_NAME)" >> ~/.bashrc
	@echo "export CLOUDFLARE_CUR_IPV6=$(CLOUDFLARE_CUR_IPV6)" >> ~/.bashrc
	@echo "export CLOUDFLARE_EMAIL=$(CLOUDFLARE_EMAIL)" >> ~/.bashrc
	@echo "export CLOUDFLARE_AUTH_KEY=$(CLOUDFLARE_AUTH_KEY)" >> ~/.bashrc
	@echo "Reloading ~/.bashrc..."
	@bash -c "source ~/.bashrc"
	@echo "✅ Environment setup complete."
