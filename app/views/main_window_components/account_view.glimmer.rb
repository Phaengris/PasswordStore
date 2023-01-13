frame {
  grid row: rows.next
  padding 0, 0, 0, 15
  visible <= [account_view, :collection_name, computed_by: :account_path, '<=': -> (v) { v.present? }]

  label {
    grid row: 0, column: 0, column_weight: 1, sticky: 'nw'
    font 'caption'
    text 'Domain'
  }

  label {
    grid row: 1, column: 0, sticky: 'nw'
    text <= [account_view, :collection_name, computed_by: :account_path]
  }

  button {
    grid row: 0, column: 1, row_span: 2, row_weight: 0, sticky: 'ne'
    width 0
    image Glimte.path('app/assets/fontawesome/buttons/copy.png').to_s
    on('command') do
      account_view.copy_domain_name_to_clipboard
    end
  }
}

frame {
  grid row: rows.next
  padding 0, 0, 0, 15

  label {
    grid row: 0, column: 0, column_weight: 1, sticky: 'nw'
    font 'caption'
    text 'Account'
  }

  label {
    grid row: 1, column: 0, sticky: 'nw'
    text <= [account_view, :name, computed_by: :account_path]
  }

  button {
    grid row: 0, column: 1, row_span: 2, row_weight: 0, sticky: 'ne'
    width 0
    image Glimte.path('app/assets/fontawesome/buttons/copy.png').to_s
    on('command') do
      account_view.copy_account_name_to_clipboard
    end
  }
}

frame {
  grid row: rows.next
  padding 0, 0, 0, 15

  label {
    grid row: 0, column: 0, column_weight: 1, sticky: 'nw'
    font 'caption'
    text 'Password'
  }

  label {
    grid row: 1, column: 0, sticky: 'nw'
    text <= [account_view, :password, '<=': -> (password) { password.present? ? password : '******' }]
  }

  button {
    grid row: 0, column: 1, row_span: 2, row_weight: 0, sticky: 'ne', padx: [0, 5]
    width 0
    image <= [account_view, :password, '<=': -> (v) {
      if v.present?
        Glimte.path('app/assets/fontawesome/buttons/eye-slash.png').to_s
      else
        Glimte.path('app/assets/fontawesome/buttons/eye.png').to_s
      end
    }]
    on('command') do
      account_view.show_or_hide_password
    end
  }

  button {
    grid row: 0, column: 2, row_span: 2, row_weight: 0, sticky: 'ne'
    width 0
    image Glimte.path('app/assets/fontawesome/buttons/copy.png').to_s
    on('command') do
      account_view.copy_password_to_clipboard
    end
  }
}

frame {
  grid row: rows.next, row_weight: 1
  padding 0

  button {
    grid row: 0, row_weight: 1, sticky: 'ne', pady: [0, 15]
    image Glimte.path('app/assets/fontawesome/buttons/pen-to-square.png').to_s
    on('command') do
      Views.edit_account_window {
        account_path account_view.account_path
      }
    end
  }

  button {
    grid row: 1, sticky: 'se'
    hidden <= [account_view, :want_delete]
    image Glimte.path('app/assets/fontawesome/buttons/trash-can.png').to_s
    on('command') do
      account_view.want_delete = true
    end
  }

  Views.shared_components.delete_confirmation {
    grid row: 1, sticky: 'se'
    padding 0
    visible <= [account_view, :want_delete]
    message "Account can't be restored after deletion."
    code_length 4

    on_action do
      begin
        account_view.delete_entity
      rescue StandardError => e
        raise_event 'FlashExceptionAlertRequest', e
      else
        raise_event 'FlashInfoRequest', <<-FLASH.squish.strip
          Account #{account_view.name} deleted
          #{"from #{account_view.collection_path}" if account_view.collection_path.present?}
        FLASH
      ensure
        account_view.want_delete = false
        raise_event 'AccountsListReloadRequest'
      end
    end
    on_cancel do
      account_view.want_delete = false
    end
  }
}

on('AccountsListSelect', redirected: true) do |event|
  account_view.account_path = event.detail
end
on('CopyPasswordRequest') do
  account_view.copy_password_to_clipboard
end
on('CopyAccountNameRequest') do
  account_view.copy_account_name_to_clipboard
end
on('CopyDomainNameRequest') do
  account_view.copy_domain_name_to_clipboard
end
on('DeleteAccountRequest') do
  account_view.want_delete = true
end
