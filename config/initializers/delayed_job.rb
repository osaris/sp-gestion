# -*- encoding : utf-8 -*-

Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.delay_jobs = !Rails.env.test?