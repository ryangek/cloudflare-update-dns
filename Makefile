# Define the path to the script and the cron job
.PHONY: add-cron list-cron remove-cron

PATH_SCRIPT := ~/Workspace/cloudflare-update-dns/cloudflare-update-dns.sh
CRON_JOB := */5 * * * * $(PATH_SCRIPT) >> ./cloudflare_ipv6.log 2>&1

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
