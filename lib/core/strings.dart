abstract final class Strings {
  static const appTitle = 'Grizzly Hills';

  static const tabHome = 'Inicio';
  static const tabLoans = 'Préstamos';
  static const tabSavings = 'Ahorro';
  static const tabBusiness = 'Negocio';
  static const tabMom = 'Mamá';

  static const settingsTitle = 'Ajustes';
  static const settingsThemeMode = 'Modo';
  static const settingsThemeScheme = 'Tema de color';
  static const themeModeSystem = 'Sistema';
  static const themeModeLight = 'Claro';
  static const themeModeDark = 'Oscuro';

  static const comingSoon = 'Próximamente';
  static const quickExpenseTooltip = 'Registrar gasto';

  static const currency = 'Bs';

  static const homeEmptyTitle = 'Todavía no abriste este mes';
  static const homeEmptyBody =
      'Registra tu sueldo y reparte tus grupos para empezar.';
  static const startMonthCta = 'Llegó mi sueldo';
  static const startMonthTitle = 'Llegó mi sueldo';
  static const startMonthConfirm = 'Abrir mes';
  static const editMonthTitle = 'Editar mes';
  static const editMonthTooltip = 'Editar sueldo y grupos';
  static const saveChanges = 'Guardar cambios';
  static const overAssignedDialogTitle = 'Sueldo insuficiente';
  static const overAssignedDialogBody =
      'Los grupos suman más que tu sueldo y el presupuesto general '
      'quedará en negativo. ¿Quieres continuar?';
  static const cancel = 'Cancelar';
  static const continueAnyway = 'Continuar igual';

  static const newExpenseTitle = 'Nuevo gasto';
  static const editExpenseTitle = 'Editar gasto';
  static const amountLabel = 'Monto';
  static const descriptionLabel = 'Descripción (opcional)';
  static const dateLabel = 'Fecha';
  static const destinationLabel = 'Destino';
  static const save = 'Guardar';
  static const delete = 'Eliminar';
  static const deleteExpenseTitle = '¿Eliminar gasto?';
  static const deleteExpenseBody = 'Esta acción no se puede deshacer.';
  static const destinationRequiredError = 'Elige un destino';
  static const openMonthFirst = 'Primero abre el mes en Inicio';
  static const insufficientBudgetTitle = 'Saldo insuficiente';
  static const insufficientBudgetExplanation =
      'Este gasto deja el grupo en negativo.';
  static const shortfallLabel = 'Te falta';
  static const requestExtension = 'Solicitar extensión';
  static const request = 'Solicitar';
  static const extensionExceedsGeneralError = 'Supera el disponible general';
  static const returnExtension = 'Devolver extensión';
  static const returnConfirm = 'Devolver';
  static const returnableExtensionLabel = 'Disponible para devolver';
  static const extensionReturnExceedsError =
      'Supera lo disponible para devolver';
  static const extensionReturnedMessage =
      'Extensión devuelta al disponible general';
  static const extensionAppliedMessage = 'Extensión registrada en imprevistos';
  static String extensionDescription(String groupName) =>
      'Extensión: $groupName';
  static String budgetWithExtension(String baseAmount, String extensionAmount) =>
      '$baseAmount + $extensionAmount ext.';
  static const generalBudgetAlsoInsufficient =
      'El presupuesto general tampoco alcanza para cubrir la diferencia.';
  static const unexpectedLabel = 'Imprevisto';
  static const unexpectedSectionTitle = 'Imprevistos';
  static const fixedSectionTitle = 'Fijos del mes';
  static const fixedPaidRowLabel = 'Fijos pagados';
  static const unexpectedRowLabel = 'Imprevistos';
  static const availableGeneralRowLabel = 'Disponible general';
  static const markFixedAmountLabel = 'Monto pagado';
  static const unmarkFixedTitle = '¿Quitar el pago?';
  static const unmarkFixedBody = 'El fijo volverá a quedar pendiente este mes.';
  static const remove = 'Quitar';
  static const pay = 'Pagar';
  static const noExpensesYet = 'Aún no hay gastos aquí';
  static const noDescription = 'Sin descripción';
  static const expenseSingular = 'gasto';
  static const expensePlural = 'gastos';
  static const budgetOfLabel = 'de';
  static const remainingLabel = 'Quedan';
  static const salaryLabel = 'Sueldo del mes';
  static const salaryRequiredError = 'Ingresa tu sueldo';
  static const invalidAmountError = 'Monto inválido';
  static String budgetBelowSpentError(String spentAmount) =>
      'Ya gastaste $spentAmount';
  static const groupsSectionTitle = 'Grupos de presupuesto';
  static const salaryRowLabel = 'Sueldo';
  static const assignedRowLabel = 'Asignado a grupos';
  static const generalBudgetRowLabel = 'Presupuesto general';
  static const overAssignedWarning = 'Asignaste más que tu sueldo';
  static const generalBelowSpentTitle = 'Presupuesto general insuficiente';
  static String generalBelowSpentBody(
    String spentAmount,
    String generalAmount,
  ) =>
      'Entre fijos, imprevistos y extensiones ya gastaste $spentAmount del '
      'presupuesto general, y con estos cambios quedaría en $generalAmount. '
      '¿Quieres continuar?';
  static String generalBelowSpentWarning(String spentAmount) =>
      'El general queda por debajo de lo ya gastado ($spentAmount)';
  static const spentLabel = 'Gastado';
  static const errorGeneric = 'Algo salió mal';

  static const savingsTotalLabel = 'Total ahorrado';
  static const savingsLocationsSectionTitle = 'Ubicaciones';
  static const savingsEmptyTitle = 'Todavía no registras tu ahorro';
  static const savingsEmptyBody =
      'Agrega dónde guardas tu dinero: bancos, caja roja, etc.';
  static const addLocationCta = 'Agregar ubicación';
  static const newLocationTitle = 'Nueva ubicación';
  static const renameLocationTitle = 'Renombrar ubicación';
  static const locationNameLabel = 'Nombre';
  static const locationNameRequiredError = 'Ingresa un nombre';
  static const deleteLocationTitle = '¿Eliminar ubicación?';
  static const deleteLocationBody = 'Esta acción no se puede deshacer.';
  static const deleteLocationHasBalanceMessage =
      'Solo puedes eliminar una ubicación vacía. Retira o transfiere '
      'su saldo primero.';
  static const rename = 'Renombrar';
  static const add = 'Agregar';
  static const deposit = 'Depositar';
  static const withdraw = 'Retirar';
  static const withdrawTooMuchError = 'No puedes retirar más de lo que hay';
  static const transferCta = 'Transferir';
  static const transferTitle = 'Transferir';
  static const transferSourceLabel = 'Desde el grupo';
  static const transferDestinationLabel = 'Hacia';
  static const transferToSavingsDescription = 'Transferencia a ahorro';
  static const transferSourceRequiredError = 'Elige un grupo de origen';
  static const transferExceedsRemainingError =
      'El grupo no tiene tanto disponible';
  static const transferDoneMessage = 'Transferencia realizada';
  static const groupAvailableLabel = 'Disponible';

  static const loansEmptyTitle = 'No tienes préstamos activos';
  static const loansEmptyBody =
      'Registra a quién le prestaste y el interés correrá solo.';
  static const newLoanCta = 'Nuevo préstamo';
  static const loanHistoryCta = 'Historial';
  static const loansTotalLabel = 'Total por cobrar hoy';
  static const editLoanTitle = 'Editar préstamo';
  static const debtorNameLabel = 'Deudor';
  static const debtorNameRequiredError = 'Ingresa el nombre del deudor';
  static const loanAmountLabel = 'Monto prestado';
  static const loanDateLabel = 'Fecha del préstamo';
  static const dueDateLabel = 'Devolución tentativa';
  static const loanBaseRowLabel = 'Base actual';
  static const loanInterestRowLabel = 'Interés acumulado';
  static const loanTotalRowLabel = 'Total a la fecha';
  static String weeklyInterestNote(String percent) =>
      'Interés del $percent semanal — la semana iniciada se cobra completa';
  static const interestRateLabel = 'Interés semanal (%)';
  static const invalidInterestRateError =
      'Ingresa un interés entero entre 1 y 100';
  static const startedWeekNote = 'La semana iniciada se cobra completa';
  static const overdueLabel = 'Vencido';
  static const dueLabel = 'Vence';
  static const registerPaymentCta = 'Registrar pago';
  static const paymentsSectionTitle = 'Pagos';
  static const noPaymentsYet = 'Aún no hay pagos';
  static const paymentClosesLoanNote =
      'Este pago cubre el total y cerrará el préstamo.';
  static const paymentRegisteredMessage = 'Pago registrado';
  static const loanClosedMessage = 'Préstamo cerrado';
  static const confirmPaymentTitle = '¿Registrar pago?';
  static const paymentIrreversibleNote =
      'Un pago registrado no se puede editar ni eliminar.';
  static const remainingDebtLabel = 'Deuda restante';
  static const confirm = 'Confirmar';
  static const deleteLoanTitle = '¿Eliminar préstamo?';
  static const deleteLoanBody = 'Esta acción no se puede deshacer.';
  static const loanHasPaymentsMessage =
      'No se puede eliminar un préstamo con pagos registrados';
  static const loanHistoryTitle = 'Historial de préstamos';
  static const loanHistoryEmptyTitle = 'Aún no hay préstamos cerrados';
  static const lentOnLabel = 'Prestado el';
  static const closedOnLabel = 'Cerrado el';

  static const monthNames = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  static String monthLabel(int year, int month) =>
      '${monthNames[month - 1]} $year';
}
