Rails.application.routes.draw do
  mount KioskLock::Engine => "/kiosk_lock"
end
