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
  static const extensionAppliedMessage = 'Extensión aplicada al grupo';
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
  static const groupsSectionTitle = 'Grupos de presupuesto';
  static const salaryRowLabel = 'Sueldo';
  static const assignedRowLabel = 'Asignado a grupos';
  static const generalBudgetRowLabel = 'Presupuesto general';
  static const overAssignedWarning = 'Asignaste más que tu sueldo';
  static const spentLabel = 'Gastado';
  static const errorGeneric = 'Algo salió mal';

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
