// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'GameTrack';

  @override
  String get login => 'Entrar';

  @override
  String get register => 'Registrar';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get forgotPassword => 'Esqueci minha senha';

  @override
  String get signInWithGoogle => 'Entrar com Google';

  @override
  String get username => 'Nome de usuário';

  @override
  String get displayName => 'Nome de exibição';

  @override
  String get home => 'Início';

  @override
  String get search => 'Buscar';

  @override
  String get upload => 'Enviar';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configurações';

  @override
  String get logout => 'Sair';

  @override
  String get follow => 'Seguir';

  @override
  String get following => 'Seguindo';

  @override
  String get unfollow => 'Deixar de seguir';

  @override
  String get likes => 'Curtidas';

  @override
  String get comments => 'Comentários';

  @override
  String get views => 'Visualizações';

  @override
  String get followers => 'Seguidores';

  @override
  String get videos => 'Vídeos';

  @override
  String get score => 'Pontos';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get myVideos => 'Meus vídeos';

  @override
  String get catalog => 'Catálogo';

  @override
  String get redeem => 'Resgatar';

  @override
  String pointsCost(int points) {
    return 'Custo: $points pontos';
  }

  @override
  String get privacy => 'Privacidade';

  @override
  String get notifications => 'Notificações';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get dark => 'Escuro';

  @override
  String get light => 'Claro';

  @override
  String get system => 'Sistema';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get share => 'Compartilhar';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String get success => 'Sucesso';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get noVideos => 'Nenhum vídeo encontrado';

  @override
  String get noUsers => 'Nenhum usuário encontrado';

  @override
  String get uploadVideo => 'Enviar vídeo';

  @override
  String get selectVideo => 'Selecionar vídeo';

  @override
  String get compressVideo => 'Comprimir vídeo';

  @override
  String get videoTitle => 'Título do vídeo';

  @override
  String get videoDescription => 'Descrição (opcional)';

  @override
  String get gameName => 'Nome do jogo (opcional)';

  @override
  String get uploading => 'Enviando...';

  @override
  String get uploadSuccess => 'Vídeo enviado com sucesso!';

  @override
  String get uploadError => 'Erro ao enviar vídeo';

  @override
  String get like => 'Curtir';

  @override
  String get unlike => 'Descurtir';

  @override
  String get alreadyLiked => 'Você já curtiu este vídeo';

  @override
  String get searchUsers => 'Buscar usuários';

  @override
  String get noResults => 'Nenhum resultado encontrado';

  @override
  String pointsEarned(int points) {
    return 'Pontos ganhos: $points';
  }

  @override
  String get insufficientPoints => 'Pontos insuficientes';

  @override
  String get redemptionSuccess => 'Resgate realizado com sucesso!';

  @override
  String get redemptionError => 'Erro ao resgatar voucher';
}
