resource "yandex_iam_service_account" "editor_sa" {
  name        = "editor-sa"
  description = "Сервисный аккаунт для управления группой ВМ."
}

resource "yandex_resourcemanager_folder_iam_member" "compute_editor" {
  folder_id = var.folder_id
  role      = "compute.editor"
  member    = "serviceAccount:${yandex_iam_service_account.editor_sa.id}"
  depends_on = [ yandex_iam_service_account.editor_sa ]
}

resource "yandex_resourcemanager_folder_iam_member" "load_balancer_editor" {
  folder_id = var.folder_id
  role      = "load-balancer.editor"
  member    = "serviceAccount:${yandex_iam_service_account.editor_sa.id}"
  depends_on = [ yandex_iam_service_account.editor_sa ]
}
