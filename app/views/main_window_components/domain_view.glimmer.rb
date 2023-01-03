frame {
  grid row: rows.next
  padding 0, 0, 0, 15

  label {
    grid row: 0, column: 0, column_weight: 1, sticky: 'nw'
    font 'caption'
    text 'Domain'
  }

  label {
    grid row: 1, column: 0, sticky: 'nw'
    text <= [domain_view, :name, computed_by: :domain_path]
  }

  button {
    grid row: 0, column: 1, row_span: 2, row_weight: 0, sticky: 'ne'
    width 0
    image Framework.asset_path('fontawesome/buttons/pen-to-square.png').to_s
  }
}

frame {
  grid row: rows.next, row_weight: 1
  padding 0, 5, 0, 0
  button {
    grid row: 0, sticky: 'se', row_weight: 1
    hidden <= [domain_view, :want_delete]
    image Framework.path('app/assets/fontawesome/buttons/trash-can.png').to_s
    on('command') do
      domain_view.want_delete = true
    end
  }
  Views.shared_components.delete_confirmation {
    grid row: 1, sticky: 'se'
    padding 0
    visible <= [domain_view, :want_delete]
    message "Domain can't be restored after deletion.\nALL accounts of this domain also will be deleted!"
    code_length 8

    on_action do
      begin
        domain_view.delete_domain
      rescue StandardError => e
        raise_event 'FlashExceptionAlertRequest', e
      else
        raise_event 'FlashInfoRequest', <<-FLASH.squish.strip
          Domain #{domain_view.name} deleted
          #{"from #{domain_view.parent.path}" if domain_view.parent.present?}
        FLASH
      ensure
        domain_view.want_delete = false
        raise_event 'AccountsListReloadRequest'
      end
    end
    on_cancel do
      domain_view.want_delete = false
    end
  }
}

on('AccountsListSelect', redirected: true) do |event|
  domain_view.domain_path = event.detail
end
on('CopyDomainNameRequest') do
  domain_view.copy_domain_name_to_clipboard
end
